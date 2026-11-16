# Verification, Validation, and Research Limitations

**Release:** `Fractalplicitive::Math` 0.01 | [Theory](THEORY.md) · [Equations](EQUATIONS.md) · [References](REFERENCES.md)

## 1. Three different levels of evidence

1. **Code verification:** Does Perl compute the specified mathematical formula for known inputs?
2. **Model validation:** Does that formula predict or reconstruct a defined reference dataset better than reasonable conventional alternatives?
3. **Physical validation:** Does independent measurement show a new physical effect, beyond established theories and instrument artifacts?

**The bundled tests address only level 1 for a limited collection of inputs.** Passing the tests cannot demonstrate a tachyon, sub-quark, altered flow of time, physical `mc³` energy, astronomical reconstruction accuracy, or improved aircraft navigation.

## 2. Reproduce the current test suite

From the distribution root (Perl 5.20+ required):

```sh
prove -lr t
```

Or use the CPAN-style build sequence:

```sh
perl Makefile.PL
make
make test
perl -Ilib examples/demo.pl
```

The suite uses Perl core `Test::More`; test files are:

| File | Tests | Scope |
|---|---:|---|
| `t/01-mathematics.t` | 14 | Time recurrences, inverse sums/weights, dimensional expressions, complex recurrences. |
| `t/02-signal-and-optics.t` | 8 | Four-mode waveform, echo samples, aperture pairs/baselines, rotation sequence. |
| `t/03-invalid-input.t` | 6 | Selected bad parameter cases, including nonconvergent inverse factor and malformed arrays. |
| **Total** | **28** | Numerical consistency and selected input validation. |

**Environment for documented reproduction:** The release was checked with Perl 5.40.1 in the creation environment; see the verification report in the release notes/output for the actual rerun result. These tests are not a full compatibility audit of Perl 5.20–5.44 or operating systems.

## 3. What the bundled tests establish

| Function or family | Tested expectation | Limits of the test |
|---|---|---|
| Original time recurrence | `fractal_time_step(1,.5,1)=1.5`; three steps end at `2.109375` | No physical-time claim. |
| Zero-start recurrence | `fractal_times(0,.5,3)` stays zero | Demonstrates important fixed-point behavior. |
| FISRARER schedule | `[0,1,1.5,1.75]` for `(0,1,.5,3)` | Not a precision timing benchmark. |
| Inverse series | Infinite limit `2`; three-term sum `1.75` for `alpha=2` | No empirical photon-energy validation. |
| Weights | Sum is approximately `1`; first of four is `8/15` | Does not test imaging reconstruction. |
| Momentum-like factor | Numerical `3*2=6` | Scaling is not physical measurement. |
| Length scaling | `16*(.5)^3 = 2` | Exact simple scalar case only. |
| `mc²` and `mc³` | Toy values `18` and `54` | Different dimensional units remain. |
| Complex recurrences | Representative tests with zero imaginary exponent | Other branch-cut behavior mostly untested. |
| Four-mode waveform | Value `4` at time zero with four unit amplitudes | No hearing or quantum interpretation. |
| Echo model | Delayed impulse `[1,0,0.5,0]` | No noise/artifact detection or real data. |
| Aperture geometry | 7 -> 21 pairs; 3 points -> 3 baselines | Does not show unique baselines or image quality. |
| Recursive rotation | 2 steps -> 3 states; final time/angle `1.5` | No moving hardware or control. |
| Invalid inputs | Six selected errors are caught | Not exhaustive property or fuzz testing. |

## 4. Recommended next tests before external publication

**Numerics and domain handling**

- Check time and inverse-series identities against independent high-precision calculations across randomized input ranges.
- Evaluate `gamma` near zero and one, large iteration counts, floating-point underflow/overflow, and negative or zero starting times.
- Check `energy_step` with genuinely complex input, negative real bases, phase transitions, near-zero values, and complex-power branch discontinuities.
- Test `displacement_step` with explicit dimensionless reference time and realistic parameter ranges.
- Test `echo_response` for empty arrays, zero taps, taps exceeding signal length, negative gains, and arbitrary known impulses.
- Check large aperture counts, duplicate points, rotated geometries, and numerical stability of baseline angles.
- Test `rotation_states` with signed angular velocities, wrapping performed externally, and timescale conversions.

**Reproducibility and compatibility**

- Test Perl versions including the declared minimum 5.20; run on Linux, macOS, and Windows where applicable.
- Add a CI workflow (e.g., GitHub Actions), a fixed random seed for any future stochastic simulations, and clear numeric tolerances.
- Review `LICENSE.txt`, `MANIFEST`, release metadata, and `Changes` before any CPAN upload.
- Record the package commit/tag, Perl version, platform, exact inputs, and console outputs for independent replication.

## 5. Controlled research comparison protocols

### 5.1 Recursive sampling versus conventional schedules

Use a known synthetic signal or recorded data with reliable timestamps. Compare:

- Uniform-time sampling.
- An established adaptive or optimized sampling strategy.
- `recursive_schedule` or `rotation_states` under matched total samples and observation duration.

Report sampling coverage, estimator bias, detection error, confidence intervals, computation time, and signal-to-noise ratio. A schedule advantage must survive repeat runs and external datasets.

### 5.2 Inverse weighting versus baseline weighting

Start from a clearly specified inverse problem (for example, reconstructing a known signal from noisy measurements). Compare uniform/variance weighting with `inverse_weights`, holding measurement information and compute resources fixed. Check holdout data and negative controls. The module currently supplies **weights only**; developers must build the reconstruction algorithm separately.

### 5.3 FISRARER echoes

Inject known impulse responses into simulated signals and verify recovery with an **independent** reference method. Distinguish ordinary multipath, reflections, filtering artifacts, and noise from any novel explanatory claim. `echo_response` generates the echo; it does not identify its physical origin.

### 5.4 Interferometric imaging

Simulate physically plausible scenes with appropriate photon budgets, aperture throughput, wavelengths, phase delays, and detector noise. Compare recursive masks with optimized nonredundant masks using the **same total collecting area**. Establish whether baseline coverage improves and whether any gain survives a complete reconstruction pipeline. As of v0.01, no such pipeline is included. JWST NIRISS AMI supplies a documented benchmark [S2].

## 6. Predeclared success/failure criteria

For each proposed experiment record:

1. **Hypothesis and null model** — what change is predicted and what would count as ordinary behavior?
2. **Data source** — synthetic, public reference data, or newly acquired observations?
3. **Controls** — matched noise, exposure, computing budget, randomization and blinding as applicable.
4. **Metrics** — specify quantitative error, uncertainty, and computing cost **before** testing.
5. **Falsification** — what observed failure rejects or limits the hypothesis?
6. **Reproduction** — code, parameters, random seeds, data permissions, and analysis scripts.

An inconclusive or negative outcome is a valid scientific result. Do not turn numerical pattern matching alone into a discovery claim.

## 7. Limits on application

- **Not flightworthy:** No avionics interfaces, independent fault handling, real-time bounds, guidance outputs, or safety certification; never attach directly to live aircraft systems.
- **Not a telescope:** No optical hardware, detector drivers, light-propagation solver, or astronomical image reconstruction.
- **Not particle detection:** No detector, empirical evidence for tachyons, sub-quarks, or time communication.
- **Not an amplifier:** Numerical momentum, energy, or harmonic scaling does not establish physical power or optical gain.
- **Not a medical tool:** No treatment or diagnostic validation.

The appropriate next milestone is an independently reproduced, preregistered comparison on a **specific numerical task** with clear baseline algorithms and reporting of uncertainty.
