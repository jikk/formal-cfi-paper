# README: Machine Check CFI CCS 2026

* CFP: https://www.sigsac.org/ccs/CCS2026/call-for/call-for-papers.html

* Notes: https://codimd.syssec.org/jDeP30sZRmyQZ9SexjXYhQ

* LucidChart link: https://lucid.app/lucidchart/937aceb8-f94e-457c-95b8-30bb51d70627/edit?invitationId=inv_2f17b57d-ee49-4cce-8d78-ef0a36c365fd

## Story Outline

- 3->4: How we implement CFI to prevent the hypothetical bug introduced in S2 or S3 and why we need Picinae to do it.
- 4->5: How Picinae lives up to the task of verifying binary rewriters without knowing their inputs/outputs and XXX.

## Page outline (budget)

Given page budget (20 + 5), the following outlines overall/rough page budget distribution.

- abs + intro: XX pgs
- background: XX pgs
- related works: XX pgs
- future works + conclusion: XX pgs

## Section Outlines

### Abstract

### Intro

### Background
- TODO: start running example of bug in an ARM CFI rewriter

### System Overview
- TODO: need to mention `abort` routine in some way.
- 50% homework (typical CFI explanation, people will just know it)
- 50% verification-friendly design decisions
- 10% motivation for why we need Picinae, why we couldn't do this before
- Program-proof codevelopment story (~5:00)

### Picinae
-

### Formal Verification

### Related Works

### Conclusion

## Misc Notes

- Python script is out of scope because there is no formal specification of an OS loader. At the very least, this would be needed to specify the correctness of the ELF editor, if not a formally verified process loader. Paper docs do not count as formal specs. (27:10)

## TODOs
* [ ] we need to mention `near-arbitrary` argument somewhere from sec 1 or 2.

* [x] set up anonymous github repo for paper code
    - https://anonymous.4open.science/

* [x] Ilan, Shreya, Charles brainstorm
    1. Formal verification friendly design decisions
    2. Bugs caught only because of the proof obligations
    3. What are the design principles for making the next binary rewriter
        * Inductive structure of the proof/correctness specification
        * Do not shuffle registers on/off the stack (though this is more for concrete code than rewriters, discovered the annoyance of this during mitre eCTF)
        * Do not use writable security state, our CFI implementation sets the security state to read-only. This abdicates us from reasoning about the possibility of invalid security stats.
        * Want all goals involving resulting states to use universal quantification. Existential quantification requires building a witness state, which requires symbolically executing a step. The infrastructure is not ready for that (ixb: but I think lifting the arm_prog+decoder+lifter all to PIL will fix this). This excludes properties such as semantic transparency in the presence of non-deterministic instructions.
* [ ] Basic examples
    1. Max completed bof, rop, fmt
    2. JOP: ixb tried and failed ot add jop by translating the example given in the tech. report. from x86 to ARMv7. Open problem. See Section 4.4 of the TR: https://www.academia.edu/909994/Jump_oriented_programming_A_new_class_of_code_reuse_attack
* [ ] Advanced examples?
    1. We could use RecIPE, an "extensible and comprehensive benchmark for evaluating memory error defenses" (https://dl.acm.org/doi/pdf/10.1145/3488932.3524127)

### figs

Figures need another revision cycle.
1. Fig1 needs to be re-drawn to serve dual purposes.
    - give a high-level workflow and system overview.
    - detailed description for CFI writer build and formal proof processes.
    - Detail we want to have:
        - Edge level with temporal/logical ordering (1), (2) ...
        - distinction between verified/unverified component
        - relation to fig2 and fig3.
        - ELF editor -> ELF packager
2. Regarding Fig2, can we add some arrows/edges associating the first and second tables?
    ixb: I tried to make the dataflow clearer.
4. I wish fig 4 can be more specific to CFI binary rewriter.
   agreed it is low priority

### Appendix
* [x] Open science
* [ ] what do we want to have on appendix?
  - Example proofs
  - Counter example cases? (indirectly stating what theorems and lemmas want to prevent from happening)

### Terms/keywords

* [ ] ISA or microarchitecture?
* [ ] ELF editor -> ELF packager
* [ ] machine check, formal verification, formal method --> three are too many; can we converge to one or two?
* [ ] a safe abort, \texttt{abort()} ...

### Minor edits
- [ ]  19% --> 19.xx %
- [ ] captions for tabs, figs, and listings.

## References (@shrya)
- [ ] check out whether  `et. al.` is okay in citations/reference.

##### tag: `pdli`,`max`, `cfi`, `formal verification`, `arm`
