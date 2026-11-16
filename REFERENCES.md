# Source Notes and References

**For:** `Fractalplicitive::Math` v0.01  
**Citation convention:** `[F#]` = originating Fractalplicitive manuscript/project; `[S#]` = established external source or software documentation.  
**Status:** This page records provenance and supporting background. **A citation does not validate the Fractalplicitive physical hypotheses.**

## A. Primary theoretical and software sources

**[F1]** T. D. Firman, *Fractalplicitive Theories*, unpublished manuscript compilation, 2026. Source material for Fractalplicitive Time Theory, Inverse Theory, complex energy and displacement recurrences, and associated cosmological and particle hypotheses. Provided by the author. No external DOI or peer-review status is claimed.

**[F2]** T. D. Firman, *Fractalplicitive Inward-Signal Reception and Recursive Echo Reconstruction (FISRARER): A Proposed Extension of the Fractalplicitive Quantum Time Telescope*, unpublished research manuscript, November 13, 2026. Source material for recursive sampling schedules and conceptual echo analysis. Provided by the author. No external DOI or peer-review status is claimed.

**[F3]** *Fractalplicitive::Math*, version 0.01, Perl source distribution (`lib/Fractalplicitive/Math.pm`, accompanying tests and `README.md`), 2026. Executable implementation of selected formulas drawn from [F1]–[F2]. Original conceptual framework attributed to Timothy Dean Firman; specific software copyright and distribution permissions should be confirmed before issuing a public license. **No repository URL, DOI, or CPAN publication is assigned here.**

**[F4]** T. D. Firman, *Fractalplicitive Quantum Time Telescope and Multiple Double-Slit Reduction*, exploratory proposal discussed as part of the ongoing Fractalplicitive research program, 2026. Background concept only; not a verified published reference or a complete software implementation. Insert a finalized manuscript citation when available.

## B. Established mathematical, physical, and technical sources

**[S1]** National Institute of Standards and Technology (NIST), "CODATA Value: Speed of Light in Vacuum," 2022 CODATA values. Defines `c = 299,792,458 m/s` exactly.  
https://physics.nist.gov/cuu/Constants/Value/c.html

**[S2]** Space Telescope Science Institute (STScI), *JWST User Documentation*, "NIRISS Aperture Masking Interferometry." Describes seven sub-apertures and 21 distinct nonredundant baselines in a working astronomical interferometric instrument.  
https://jwst-docs.stsci.edu/jwst-near-infrared-imager-and-slitless-spectrograph/niriss-observing-modes/niriss-aperture-masking-interferometry

**[S3]** B. B. Mandelbrot, *The Fractal Geometry of Nature*. W. H. Freeman, 1982. Foundational mathematical and conceptual background for self-similarity and fractal geometry; not evidence for any specific Fractalplicitive cosmological claim.

**[S4]** Perl Documentation, "Math::Complex — complex numbers and associated mathematical functions." Documents the core complex-number library used for the proposed normalized energy/displacement recurrences.  
https://perldoc.perl.org/Math::Complex

**[S5]** Perl Documentation, "Test::More — yet another framework for writing test scripts." Documents the testing framework used by the bundled `t/*.t` files.  
https://perldoc.perl.org/Test::More

**[S6]** Perl Documentation, "ExtUtils::MakeMaker — Create a module Makefile." Documents the Perl distribution build system used by `Makefile.PL`.  
https://perldoc.perl.org/ExtUtils::MakeMaker

**[S7]** NIST, *The International System of Units (SI)*, NIST Special Publication 330, section 2. Reference for fundamental units, dimensions, and the exact speed of light constant.  
https://www.nist.gov/pml/special-publication-330/sp-330-section-2

## C. Source-to-function crosswalk

| Mathematical subject | Functions | Origin or reference |
|---|---|---|
| Manuscript time recurrence | `fractal_time_step`, `fractal_times` | [F1] |
| Recursive observation schedule | `recursive_schedule` | [F2] |
| Inverse scaling and momentum-like factor | `inverse_geometric_sum`, `inverse_weights`, `photon_inverse_momentum` | [F1] and standard geometric-series mathematics |
| Recursive length | `fractal_length` | [F1], generalized mathematical scaling |
| Complex energy and displacement recurrences | `energy_step`, `displacement_step` | [F1], [S4] |
| `mc²` and `mc³` comparison | `rest_energy`, `mc3_quantity` | [F1], [S1], [S7]; only `mc²` has energy units |
| Four-oscillator waveform | `tetra_wave` | Proposed harmonization concepts [F1]; implemented as classical cosine sum |
| Echoes | `echo_response` | FISRARER [F2]; conventional tapped-delay construction |
| Aperture pairs and geometry | `aperture_pair_count`, `aperture_baselines` | [F4] (proposed application), [S2] (established instrument example) |
| Recursive rotation | `rotation_states` | [F2] (time schedule), [F4] (proposed lens-array concept) |
| Packaging and automated tests | `Makefile.PL`, `t/*.t` | [F3], [S5], [S6] |

## D. Appropriate attribution and manuscript publication

The research manuscripts [F1], [F2], and [F4] should **not** be represented as independently peer-reviewed studies. Software verification, replication of a mathematical identity, and empirical support for a proposed new physical mechanism are different claims; see [VALIDATION.md](VALIDATION.md).

When the author publishes a permanent public version, update this file with exact manuscript titles, publication dates, stable links/DOIs, and any revised software version number. Keep the original source attribution and the software license distinct: `LICENSE.txt` remains a pending-license notice as of v0.01.
