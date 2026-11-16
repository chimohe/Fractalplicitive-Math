# Equations and API Reference

**Project:** `Fractalplicitive::Math` 0.01 | [Theory](THEORY.md) · [Validation](VALIDATION.md) · [References](REFERENCES.md)

This page documents the **actual implementation** in `lib/Fractalplicitive/Math.pm`, rather than a wish list of future functions. All 16 functions are **optional exports**: import the names you need. Perl 5.20+ and only core modules are required. Unless stated otherwise, numerical inputs must be finite real scalars; invalid values generally throw exceptions (`die`).

```perl
use strict;
use warnings;
use Fractalplicitive::Math qw(
    fractal_times recursive_schedule inverse_weights
    tetra_wave echo_response aperture_pair_count rotation_states
);
```

**Index convention:** An iteration index `n` always means a discrete index, **not** a physical timestamp unless an application supplies that interpretation. The parameter name `alpha` is used in **different formulas for different meanings**: inverse scaling factor versus complex exponent coefficient. Do not silently identify them.

## 1. Recursive time and observation schedules

### 1.1 Original manuscript recurrence

\[
t_n = t_{n-1}(1+\gamma^n), \qquad n\geq 1,\quad \gamma>0.
\]

- `fractal_time_step($previous, $gamma, $n)` returns a **single real scalar**.
- `fractal_times($initial, $gamma, $steps)` returns an **array reference**, including `t_0`; its length is `steps + 1`.
- Validations: positive `gamma`, integer `n >= 1`, integer `steps >= 0`, finite values/results.

Example: `fractal_times(1, 0.5, 3)` returns `[1, 1.5, 1.875, 2.109375]`.

**Important:** `fractal_times(0, 0.5, 3)` is `[0,0,0,0]` because the recurrence multiplies the previous value. This formula is **not** interchangeable with a series of independent sample intervals.

### 1.2 FISRARER engineering sampling schedule

\[
T_{n+1}=T_n + \Delta T_0\gamma^n, \qquad n\geq0.
\]

- `recursive_schedule($start, $dt0, $gamma, $steps)` returns `[T_0,...,T_steps]` as an **array reference**.
- `dt0 > 0`, `gamma > 0`, `steps >= 0` integer.
- Example: `recursive_schedule(0, 1, 0.5, 3)` gives `[0, 1, 1.5, 1.75]`.

These are **scheduled analysis/sample coordinates**, not evidence that external clock time changes. Sampling gaps shrink for `0 < gamma < 1` and grow for `gamma > 1`.

## 2. Inverse Theory: geometric scaling

### 2.1 Convergent inverse sum

\[
G_\infty(\alpha)=\sum_{n=0}^\infty\alpha^{-n}
=\frac{1}{1-\alpha^{-1}},\qquad \alpha>1.
\]

For `terms = K` the code uses

\[
G_K(\alpha)=\sum_{n=0}^{K-1}\alpha^{-n}
=\frac{1-\alpha^{-K}}{1-\alpha^{-1}},\qquad K\geq1.
\]

- `inverse_geometric_sum($alpha, [$terms])`: scalar; omitting `terms` returns the infinite-series limit.
- Example: `inverse_geometric_sum(2) = 2`; `inverse_geometric_sum(2, 3) = 1.75`.

### 2.2 Normalized weights

\[
w_n=\frac{\alpha^{-n}}{\sum_{k=0}^{L-1}\alpha^{-k}},\quad n=0,\ldots,L-1.
\]

- `inverse_weights($alpha, $levels)` returns an **array reference** of exactly `levels` weights.
- `alpha > 1`, integer `levels >= 1`, weights sum to approximately 1 subject to floating-point rounding.
- Example: `inverse_weights(2, 4)` gives `[8/15, 4/15, 2/15, 1/15]` numerically.
- Suggested use: comparative weighting experiments; **no** image reconstruction algorithm is built into this function.

### 2.3 Numerical momentum scaling

\[
p_{\mathrm{candidate}}=p\,G_K(\alpha),
\]

where `K` may be omitted for the convergent limit.

- `photon_inverse_momentum($p, $alpha, [$terms])` returns a **real scalar**.
- Example: `photon_inverse_momentum(3, 2)` gives `6`.
- **Status:** Numeric representation of the author's conjecture. It does **not** establish a new physical photon energy–momentum relationship; for real photons the established relation remains `E = pc`.

## 3. Recursive spatial scaling

\[
L_n=L_0\gamma^n,\quad n\geq0.
\]

- `fractal_length($base, $gamma, $n)` returns a real scalar.
- Example: `fractal_length(16, 0.5, 3)` returns `2`.
- If `base` carries a length unit, output uses the same unit; `gamma` is dimensionless.

## 4. Speculative complex-valued recurrences

**Normalization requirement:** The original manuscript writes complex powers and exponentials of quantities described as energy and time. For the implemented equations to be mathematically coherent, inputs are treated as **dimensionless normalized variables** `e_n`, `s_n`, and `tau_n`. A future physical model would need to specify `e_n = E_n/E_ref`, `tau_n = t_n/t_ref` and an appropriate scale for `s_n`. Neither `E_ref` nor `t_ref` is chosen by this module.

Let `f_n = beta^n`, `h_n = 1/f_n`, with `beta > 0`.

### 4.1 Complex energy-like recurrence

\[
e_n=f_n\left(e_{n-1}\right)^{1+i\alpha}+h_n.
\]

- `energy_step($previous, $beta, $alpha, $n)` returns `Math::Complex`.
- `previous`: finite real or `Math::Complex`; `beta > 0`; `alpha` finite real; integer `n >= 0`.
- Example: `energy_step(1, 2, 0, 1)` returns complex `2.5 + 0i`.
- Complex exponentiation follows Perl `Math::Complex` behavior; phase/branch conventions matter. Negative and zero bases with noninteger/complex powers need special attention.
- **No inference of free energy, tachyons, or actual physical gain follows from a numerical output.**

### 4.2 Complex displacement-like recurrence

\[
s_n=s_{n-1}\left(1+f_n e^{i\alpha\tau_n}-h_n\right).
\]

- `displacement_step($previous, $time, $beta, $alpha, $n)` returns `Math::Complex`.
- `previous`: finite real or `Math::Complex`; `time` (normalized `tau_n`): finite real; `beta > 0`; integer `n >= 0`.
- Example: `displacement_step(2, 0, 2, 0, 1)` returns `5 + 0i`.
- The product `alpha*time` must be dimensionless; a complex result is not a measured trajectory.

## 5. Physical dimensional comparison: `mc²` and `mc³`

\[
E_0=mc^2,\qquad Q_3=mc^3.
\]

- `rest_energy($mass, $c)`: scalar `m*c**2`. In SI with `m` in kg and `c` in m/s, units are joules (`kg m² s⁻²`).
- `mc3_quantity($mass, $c)`: scalar `m*c**3`. In SI, units are `kg m³ s⁻³ = J·m/s`, **not joules**. It cannot be inserted into an energy balance as though it had units of energy.
- `mass` finite real (code does not require nonnegative values); `c > 0`.
- Example with **toy** `m=2`, `c=3`: `rest_energy(2,3)=18`, `mc3_quantity(2,3)=54`. These toy values do not represent the physical speed of light.
- NIST defines physical `c = 299792458 m/s` exactly; supply this yourself if doing SI calculations [S1].

## 6. Four-mode classical harmonic simulation

\[
W(t)=\sum_{j=1}^4 A_j\cos\!\left(2\pi f_j t+\phi_j\right).
\]

- `tetra_wave($time, \@amplitudes, \@frequencies, \@phases)` returns a scalar sample.
- Each reference **must** refer to an array containing exactly four finite numbers.
- Units: if `f_j` is hertz then `time` is seconds; phases are radians. Amplitude unit is application-defined.
- Example: `tetra_wave(0, [(1)x4], [1,2,3,4], [(0)x4])` returns `4`.
- This is a classical oscillator sum. Binaural beats in biological hearing, phase-locked quantum fields, and matter creation are not modeled by the function.

## 7. Echo simulation: FISRARER

Discrete-time tapped-delay model:

\[
y[n]=\sum_{k} a_k\,x[n-d_k].
\]

Input samples outside the finite input array are treated as zero.

- `echo_response(\@input, \@taps)` returns an output **array reference with the same length as input**.
- Each tap is a hash reference `{delay => nonnegative_integer, gain => finite_real}`.
- Example:

```perl
my $out = echo_response([1,0,0,0], [
  {delay => 0, gain => 1},
  {delay => 2, gain => 0.5},
]);
# [1, 0, 0.5, 0]
```

- Delays are integer **sample counts**, not seconds; conversion requires a separate sample rate. Output is truncated to the input length. No noise generator, source classifier, matched filter, or detector is included.

## 8. Multiple-aperture geometry

### 8.1 Potential pair count

\[
M=\frac{N(N-1)}{2}.
\]

- `aperture_pair_count($apertures)` returns a number; input must be integer `N >= 2`.
- Example: `aperture_pair_count(7)` returns `21` potential pairs.
- The number of **distinct baseline vectors** may be lower in a redundant array. JWST NIRISS uses seven nonredundant sub-apertures / 21 baselines [S2].

### 8.2 Two-dimensional baselines

For positions `r_i = (x_i,y_i)`, with `i < j`,

\[
\Delta x=x_j-x_i,\quad\Delta y=y_j-y_i,\quad
b=\sqrt{\Delta x^2+\Delta y^2},\quad
\theta=\operatorname{atan2}(\Delta y,\Delta x).
\]

- `aperture_baselines(\@points)` accepts at least two `[x,y]` arrays and returns an array reference of hashes with keys: `i`, `j`, `dx`, `dy`, `length`, `angle_rad`.
- Output order follows nested loops `i=0..N-2` and `j=i+1..N-1`.
- Geometry only: no wave propagation, visibility estimation, wavelength scaling, or reconstructed image.

## 9. Recursive rotation states

For steps `n = 0 ... steps-1`:

\[
\Delta T_n=\Delta T_0\gamma^n,\qquad
\omega_n=\omega_0\beta^n,
\]
\[
T_{n+1}=T_n+\Delta T_n,\qquad
\theta_{n+1}=\theta_n+\omega_n\Delta T_n.
\]

- `rotation_states($theta0, $omega0, $beta, $time0, $dt0, $gamma, $steps)` returns an array reference of `steps+1` hashes: `n`, `time`, `theta_rad`.
- `theta0` and `omega0` can be finite signed values; `beta`, `dt0`, and `gamma` must be positive; `steps` integer >= 0.
- `theta_rad` is **unwrapped** (not reduced modulo `2*pi`). If time is seconds, `omega0` should be radians/second.
- Example: `rotation_states(0,1,1,0,1,0.5,2)` produces final `time=1.5`, `theta_rad=1.5`.
- This calculates candidate schedules only; no motors, feedback, clocks, hardware, or physical telescope are controlled.

## 10. Reproducible execution

```sh
perl -Ilib examples/demo.pl
prove -lr t
```

To inspect the module's embedded API reference:

```sh
perldoc -F lib/Fractalplicitive/Math.pm
```

See [VALIDATION.md](VALIDATION.md) for test coverage and [REFERENCES.md](REFERENCES.md) for manuscript/source attribution.
