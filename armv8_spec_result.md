# armcfi: spec 2026 performance evaluation

We conducted performance evaluation for armv8 implementation and the following is the result.

## Call Emulation 

* Call Emulation
* Originally, we translate
*
* ```
* bl .label
* ```
*
* to be 
*
* ```
* mov lr, oldpc + 4
* b .label
* ```
*
* * This turn to generate unexpected high overhead as it penalize the CPU level (shadow) stack-based speculation (https://support.arm.com/documentation/100798/0401/L1-memory-system/L1-instruction-memory-system/Program-flow-prediction?utm_source=chatgpt.com).
*
*
*
*
* * Call Emulation Improved
*
*
* The following strategy improved the performance siginficantly, even though it added 
*  
*  ```
*      b L2
*      L1: mov lr, oldpc+4
*          b dest
*          L2: bl L1
*          ```
*
*          turns out it is much faster to do above, even though this adds two unnecessary branches, since it still sets the return stack to the correct value. i got ntest from 123% to 19% overhead on m3.
*
*          ## M3 Max (running on Debian 13 atop Mackbook Pro + VMWare)
*
*          | benchmark      | base time   | cfi time            | cfi (call emulation) time | cfi overhead | cfi (ce) overhead | cfi ce improved | cfi_ce overhead |         cfi_ce_improved_again    |         cfi_ce_improved_again overhad    | # of indirect branches | ind branch/s |
*          |----------------|-------------|---------------------|---------------------------|--------------|-------------------|-----------------|-----------------|----------------------------------|------------------------------------------|------------------------|--------------|
*          | 706.stockfish  | 173         | 176                 | 204                       | 1.73%        | 17.92%            | 181             | 4.62%           | 177                              | 2.31%                                    | 7449995490             | 42090370     |
*          | 707.ntest      | 132         | runtime fail        | 295                       | n/a          | 123.48%           | 156             | 18.18%          | 157                              | 18.94%                                   | 30504798063            | 231096955    |
*          | 708.sqlite     | 128         | 136                 | 227                       | 6.25%        | 77.34%            | 166             | 29.69%          | 143                              | 11.72%                                   | 38776049632            | 302937887.8  |
*          | 710.omnetpp    | 84.3        | runtime fail        | 383                       | n/a          | 354.33%           | 254             | 201.30%         | 129                              | 53.02%                                   | 75025665350            | 889984167.9  |
*          | 714.cpython    | 76.6        | 90.5                | 254                       | 18.15%       | 231.59%           | 148             | 93.21%          | 100                              | 30.55%                                   | 50384883975            | 657766109.3  |
*          | 721.gcc        | 114         | 122                 | 219                       | 7.02%        | 92.11%            | 145             | 27.19%          | 131                              | 14.91%                                   | 23393165018            | 205203201.9  |
*          | 723.llvm       | 109         | OOM while rewriting | OOM while rewriting       | n/a          |                   |                 |                 |                                  |                                          |                        |              |
*          | 727.cppcheck   | 87.7        | 90.1                | 212                       | 2.74%        | 141.73%           | 106             | 20.87%          | 102                              | 16.31%                                   | 26489758316            | 302049695.7  |
*          | 729.abc        | 101         | 105                 | 130                       | 3.96%        | 28.71%            | 110             | 8.91%           | 113                              | 11.88%                                   | 6580427350             | 65152746.04  |
*          | 734.vpr        | 96.1        | 102                 | 224                       | 6.14%        | 133.09%           | 119             | 23.83%          | 110                              | 14.46%                                   | 28345165083            | 294954891.6  |
*          | 735.gem5       | 83.5        | 101                 | 239                       | 20.96%       | 186.23%           | 153             | 83.23%          | 108                              | 29.34%                                   | 33264747861            | 398380213.9  |
*          | 750.sealcrypto | 100         | runtime fail        | 174                       | n/a          | 74.00%            | 106             | 6.00%           | 106                              | 6.00%                                    | 17061167674            | 170611676.7  |
*          | 753.ns3        | 94          | 119                 | 355                       | 26.60%       | 277.66%           | 197             | 109.57%         | 134                              | 42.55%                                   | 46435491359            | 493994588.9  |
*          | 777.zstd       | 148         | 149                 | 160                       | 0.68%        | 8.11%             | 153             | 3.38%           | 152                              | 2.70%                                    | 2668033941             | 18027256.36  |
*          | average        | 109.0857143 | 119.06              | 236.6153846               | 9.42%        | 134.33%           |                 | 48.46%          |                                  | 19.59%                                   |                        |              |
*
*
*          ## Raspberry Pi 5 + 16 GB DRAM
*
*
*          | benchmark      | base time | cfi time | cfi (call emulation) time | cfi overhead | cfi (ce) overhead | cfi ce improved | cfi_ce overhead |         cfi_ce_improved_again    |         cfi_ce_improved_again overhad    |
*          |----------------|-----------|----------|---------------------------|--------------|-------------------|-----------------|-----------------|----------------------------------|------------------------------------------|
*          | 706.stockfish  | 373       | 387      | 411                       | 3.75%        | 10.19%            | 396             | 6.17%           | 393                              | 5.36%                                    |
*          | 707.ntest      | 392       | fail     | 546                       |              | 39.29%            | 460             | 17.35%          | 463                              | 18.11%                                   |
*          | 708.sqlite     | 369       | 403      | 447                       | 9.21%        | 21.14%            | 438             | 18.70%          | 428                              | 15.99%                                   |
*          | 710.omnetpp    | 324       | fail     | 678                       |              | 109.26%           | 595             | 83.64%          | 553                              | 70.68%                                   |
*          | 714.cpython    | 264       | 325      | 452                       | 23.11%       | 71.21%            | 433             | 64.02%          | 382                              | 44.70%                                   |
*          | 721.gcc        | 503       | 552      | 655                       | 9.74%        | 30.22%            | 602             | 19.68%          | 578                              | 14.91%                                   |
*          | 723.llvm       | 329       |          |                           |              |                   |                 |                 |                                  |                                          |
*          | 727.cppcheck   | 256       | 278      | 365                       | 8.59%        | 42.58%            | 313             | 22.27%          | 301                              | 17.58%                                   |
*          | 729.abc        | 286       | 294      | 306                       | 2.80%        | 6.99%             | 300             | 4.90%           | 299                              | 4.55%                                    |
*          | 734.vpr        | 351       | 390      | 477                       | 11.11%       | 35.90%            | 418             | 19.09%          | 410                              | 16.81%                                   |
*          | 735.gem5       | 264       | 325      | 442                       | 23.11%       | 67.42%            | 400             | 51.52%          | 383                              | 45.08%                                   |
*          | 750.sealcrypto | 370       | fail     | 486                       |              | 31.35%            | 393             | 6.22%           | 393                              | 6.22%                                    |
*          | 753.ns3        | 329       | 455      | 704                       | 38.30%       | 113.98%           | 637             | 93.62%          | 608                              | 84.80%                                   |
*          | 777.zstd       | 480       | 486      | 496                       | 1.25%        | 3.33%             | 486             | 1.25%           | 477                              | -0.63%                                   |
*          | average        | 349.29    | 389.5    | 497.31                    | 13.10%       | 44.84%            |                 | 31.42%          |                                  | 26.47%                                   |
*          ---
*          * OOM: Out-Of-Memory
