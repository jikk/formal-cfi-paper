# README: Machine Check CFI CCS 2026

* CFP: https://www.sigsac.org/ccs/CCS2026/call-for/call-for-papers.html

* Notes: https://codimd.syssec.org/jDeP30sZRmyQZ9SexjXYhQ

* LucidChart link: https://lucid.app/lucidchart/937aceb8-f94e-457c-95b8-30bb51d70627/edit?invitationId=inv_2f17b57d-ee49-4cce-8d78-ef0a36c365fd

## Story Outline

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

* [ ] better name for `ELF Editor`
    - `ELF Repackager`, `ELF Composer`, `ELF Reconstructor`, `ELF Rebuilder`


##### tag: `pdli`,`max`, `cfi`, `formal verification`, `arm`
