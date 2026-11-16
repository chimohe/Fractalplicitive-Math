package Fractalplicitive::Math;

use strict;
use warnings;
use Exporter 'import';
use Math::Complex qw(cplx Re Im);
use POSIX qw(isfinite);
use Scalar::Util qw(looks_like_number);

our $VERSION = '0.01';
our @EXPORT_OK = qw(
    fractal_time_step fractal_times recursive_schedule
    inverse_geometric_sum inverse_weights photon_inverse_momentum
    fractal_length energy_step displacement_step
    rest_energy mc3_quantity
    tetra_wave echo_response
    aperture_pair_count aperture_baselines rotation_states
);

sub _real {
    my ($value, $label) = @_;
    die "$label is required\n" unless defined $value;
    die "$label must be a finite real number\n"
        if ref($value) || !looks_like_number($value) || !isfinite($value);
    return 0 + $value;
}

sub _integer {
    my ($value, $label, $min) = @_;
    $value = _real($value, $label);
    die "$label must be an integer >= $min\n"
        if $value != int($value) || $value < $min;
    return int($value);
}

sub _positive {
    my ($value, $label) = @_;
    $value = _real($value, $label);
    die "$label must be > 0\n" unless $value > 0;
    return $value;
}

sub _finite_result {
    my ($value, $label) = @_;
    die "$label overflowed or was not finite\n" unless isfinite($value);
    return $value;
}

# Original manuscript: t_n = t_(n-1) (1 + gamma**n), with n starting at 1.
sub fractal_time_step {
    my ($previous, $gamma, $n) = @_;
    $previous = _real($previous, 'previous time');
    $gamma = _positive($gamma, 'gamma');
    $n = _integer($n, 'iteration n', 1);
    return _finite_result($previous * (1 + $gamma ** $n), 'fractal time');
}

sub fractal_times {
    my ($initial, $gamma, $steps) = @_;
    $initial = _real($initial, 'initial time');
    $gamma = _positive($gamma, 'gamma');
    $steps = _integer($steps, 'steps', 0);
    my @times = ($initial);
    for my $n (1 .. $steps) {
        push @times, fractal_time_step($times[-1], $gamma, $n);
    }
    return \@times;
}

# Engineering sampling schedule from FISRARER: t_(n+1) = t_n + dt0*gamma**n.
sub recursive_schedule {
    my ($start, $dt0, $gamma, $steps) = @_;
    $start = _real($start, 'start');
    $dt0 = _positive($dt0, 'initial time step');
    $gamma = _positive($gamma, 'gamma');
    $steps = _integer($steps, 'steps', 0);
    my @times = ($start);
    for my $n (0 .. $steps - 1) {
        my $dt = _finite_result($dt0 * $gamma ** $n, 'time interval');
        push @times, _finite_result($times[-1] + $dt, 'scheduled time');
    }
    return \@times;
}

sub inverse_geometric_sum {
    my ($alpha, $terms) = @_;
    $alpha = _real($alpha, 'alpha');
    die "alpha must be > 1 for convergent inverse scaling\n" unless $alpha > 1;
    if (!defined $terms) {
        return 1 / (1 - 1 / $alpha);
    }
    $terms = _integer($terms, 'terms', 1);
    # Stable closed form for the partial sum 0..terms-1.
    return _finite_result((1 - $alpha ** (-$terms)) / (1 - 1/$alpha), 'inverse sum');
}

sub inverse_weights {
    my ($alpha, $levels) = @_;
    $alpha = _real($alpha, 'alpha');
    die "alpha must be > 1\n" unless $alpha > 1;
    $levels = _integer($levels, 'levels', 1);
    my @raw = map { $alpha ** (-$_) } (0 .. $levels - 1);
    my $sum = 0;
    $sum += $_ for @raw;
    return [ map { $_ / $sum } @raw ];
}

sub photon_inverse_momentum {
    my ($p, $alpha, $terms) = @_;
    $p = _real($p, 'momentum');
    return _finite_result($p * inverse_geometric_sum($alpha, $terms), 'scaled momentum');
}

sub fractal_length {
    my ($base, $gamma, $n) = @_;
    $base = _real($base, 'base length');
    $gamma = _positive($gamma, 'gamma');
    $n = _integer($n, 'iteration n', 0);
    return _finite_result($base * $gamma ** $n, 'fractal length');
}

# Original speculative algebra, implemented on dimensionless normalized quantities.
# Returns a Math::Complex object; never interpret as physical evidence of gain.
sub energy_step {
    my ($previous, $beta, $alpha, $n) = @_;
    $previous = _real($previous, 'normalized previous energy') unless ref($previous);
    die "previous energy must be a number or Math::Complex\n"
        if ref($previous) && !eval { $previous->isa('Math::Complex') };
    $beta = _positive($beta, 'beta');
    $alpha = _real($alpha, 'alpha');
    $n = _integer($n, 'iteration n', 0);
    my $f = _finite_result($beta ** $n, 'direct scaling f');
    die "direct scaling f must be nonzero\n" if $f == 0;
    my $h = 1/$f;
    my $z = ref($previous) ? $previous : cplx($previous, 0);
    my $result = $f * ($z ** cplx(1, $alpha)) + $h;
    die "complex energy not finite\n" unless isfinite(Re($result)) && isfinite(Im($result));
    return $result;
}

# Original speculative algebra: S_n = S_prev * (1 + f*exp(i*alpha*t_n) - h)
sub displacement_step {
    my ($previous, $time, $beta, $alpha, $n) = @_;
    $previous = _real($previous, 'previous displacement') unless ref($previous);
    die "previous displacement must be a number or Math::Complex\n"
        if ref($previous) && !eval { $previous->isa('Math::Complex') };
    $time = _real($time, 'time');
    $beta = _positive($beta, 'beta');
    $alpha = _real($alpha, 'alpha');
    $n = _integer($n, 'iteration n', 0);
    my $f = _finite_result($beta ** $n, 'direct scaling f');
    die "direct scaling f must be nonzero\n" if $f == 0;
    my $h = 1/$f;
    my $z = ref($previous) ? $previous : cplx($previous, 0);
    my $result = $z * (1 + $f * exp(cplx(0, $alpha*$time)) - $h);
    die "complex displacement not finite\n" unless isfinite(Re($result)) && isfinite(Im($result));
    return $result;
}

sub rest_energy {
    my ($mass, $c) = @_;
    $mass = _real($mass, 'mass');
    $c = _positive($c, 'speed c');
    return _finite_result($mass * $c ** 2, 'rest energy');
}

# Units of mc^3 are J*m/s (energy times speed), NOT joules.
sub mc3_quantity {
    my ($mass, $c) = @_;
    $mass = _real($mass, 'mass');
    $c = _positive($c, 'speed c');
    return _finite_result($mass * $c ** 3, 'mc3 quantity');
}

sub tetra_wave {
    my ($time, $amplitudes, $frequencies, $phases) = @_;
    $time = _real($time, 'time');
    for my $pair ([amplitudes=>$amplitudes], [frequencies=>$frequencies], [phases=>$phases]) {
        die "$pair->[0] must have exactly four values\n"
            unless ref($pair->[1]) eq 'ARRAY' && @{$pair->[1]} == 4;
    }
    my $pi = 4 * atan2(1, 1);
    my $sum = 0;
    for my $i (0..3) {
        my $amp = _real($amplitudes->[$i], "amplitudes[$i]");
        my $freq = _real($frequencies->[$i], "frequencies[$i]");
        my $phase = _real($phases->[$i], "phases[$i]");
        $sum += $amp*cos(2*$pi*$freq*$time + $phase);
    }
    return _finite_result($sum, 'tetra waveform');
}

# Input/taps define a discrete linear echo model, no actual detector interaction.
sub echo_response {
    my ($input, $taps) = @_;
    die "input must be an array reference\n" unless ref($input) eq 'ARRAY';
    die "taps must be an array reference\n" unless ref($taps) eq 'ARRAY';
    my @out = (0) x scalar(@$input);
    for my $tap (@$taps) {
        die "each tap must be a {delay, gain} hash\n" unless ref($tap) eq 'HASH';
        my $delay = _integer($tap->{delay}, 'tap delay', 0);
        my $gain = _real($tap->{gain}, 'tap gain');
        for my $n ($delay .. $#out) {
            $out[$n] += $gain * _real($input->[$n - $delay], 'input sample');
        }
    }
    _finite_result($_, 'echo sample') for @out;
    return \@out;
}

sub aperture_pair_count {
    my ($count) = @_;
    $count = _integer($count, 'apertures', 2);
    return $count * ($count - 1)/2;
}

sub aperture_baselines {
    my ($points) = @_;
    die "points must be an array reference of at least two [x,y] entries\n"
        unless ref($points) eq 'ARRAY' && @$points >= 2;
    for my $i (0..$#$points) {
        die "point $i must be [x,y]\n"
            unless ref($points->[$i]) eq 'ARRAY' && @{$points->[$i]} == 2;
        _real($points->[$i][0], "point $i x");
        _real($points->[$i][1], "point $i y");
    }
    my @out;
    for my $i (0..$#$points - 1) {
        for my $j ($i+1..$#$points) {
            my $dx = $points->[$j][0] - $points->[$i][0];
            my $dy = $points->[$j][1] - $points->[$i][1];
            push @out, {
                i => $i, j => $j, dx => $dx, dy => $dy,
                length => sqrt($dx**2+$dy**2), angle_rad => atan2($dy, $dx)
            };
        }
    }
    return \@out;
}

# Two related mathematical schedules: time increments gamma**n and angular-rate beta**n.
sub rotation_states {
    my ($theta0, $omega0, $beta, $time0, $dt0, $gamma, $steps) = @_;
    $theta0 = _real($theta0, 'theta0');
    $omega0 = _real($omega0, 'omega0');
    $beta = _positive($beta, 'beta');
    $time0 = _real($time0, 'time0');
    $dt0 = _positive($dt0, 'dt0');
    $gamma = _positive($gamma, 'gamma');
    $steps = _integer($steps, 'steps', 0);
    my ($theta, $time) = ($theta0, $time0);
    my @out = ({n => 0, time => $time, theta_rad => $theta});
    for my $n (0..$steps-1) {
        my $dt = $dt0 * $gamma**$n;
        my $omega = $omega0 * $beta**$n;
        $theta = _finite_result($theta + $omega*$dt, 'theta');
        $time = _finite_result($time + $dt, 'time');
        push @out, { n => $n+1, time => $time, theta_rad => $theta };
    }
    return \@out;
}

1;

__END__

=head1 NAME

Fractalplicitive::Math - Experimental implementation of Fractalplicitive mathematical formulas

=head1 SYNOPSIS

  use Fractalplicitive::Math qw(
      fractal_times recursive_schedule inverse_weights aperture_pair_count
  );
  my $times = fractal_times(1, 0.5, 3);            # [1, 1.5, 1.875, 2.109375]
  my $schedule = recursive_schedule(0, 1, 0.5, 3); # [0, 1, 1.5, 1.75]
  my $weights = inverse_weights(2, 4);           # sums to 1
  print aperture_pair_count(7);                  # 21

=head1 DESCRIPTION

This teaching and simulation library expresses formulas from T. D. Firman's
unpublished Fractalplicitive Theories and FISRARER manuscripts as testable
algorithms. No physical validation is implied. The energy and displacement
recurrences use dimensionless, normalized quantities and complex arithmetic.
They are not calibrated models of measured energy, tachyon motion or spacetime.

C<mc3_quantity> computes the numeric expression m*c^3, whose SI dimensions
are energy multiplied by speed, not energy. No aviation, spaceflight, medical,
or safety-critical use is authorized or implied.

=head1 FUNCTIONS

=over 4

=item fractal_time_step($previous, $gamma, $n)

Original manuscript recurrence for n >= 1. If the starting time is zero, all
subsequent values are zero.

=item fractal_times($initial, $gamma, $steps)

Returns an array reference including the initial value.

=item recursive_schedule($start, $dt0, $gamma, $steps)

Practical sampling schedule for FISRARER (distinct from the original recurrence).

=item inverse_geometric_sum($alpha, [$terms])

Infinite convergent sum if terms omitted (alpha > 1); otherwise finite sum.

=item inverse_weights($alpha, $levels)

Normalized level weights for a reconstruction experiment.

=item photon_inverse_momentum($p, $alpha, [$terms])

Applies the manuscript's inverse geometric factor to p numerically; does not
establish a modified physical photon momentum law.

=item fractal_length($base, $gamma, $n)

Computes L_n = L_0 * gamma^n.

=item energy_step($previous, $beta, $alpha, $n)

Complex-valued version of the manuscript's normalized energy recurrence.

=item displacement_step($previous, $time, $beta, $alpha, $n)

Complex-valued version of the manuscript's displacement recurrence.

=item rest_energy($m, $c)

Computes m*c^2 (SI energy if m in kg and c in m/s).

=item mc3_quantity($m, $c)

Computes m*c^3, which is NOT an energy in SI units.

=item tetra_wave($time, \@amplitudes, \@frequencies, \@phases)

Four-mode classical oscillator model of the proposed tetraformed waveform idea.

=item echo_response(\@signal, \@taps)

Discrete echo simulation. Taps are hashrefs with integer delay and gain.

=item aperture_pair_count($apertures)

Computes unique pair count N(N-1)/2.

=item aperture_baselines(\@points)

Computes Cartesian baselines for a two-dimensional aperture array.

=item rotation_states($theta0,$omega0,$beta,$time0,$dt0,$gamma,$steps)

Computes conceptual recursive time/angular orientation states (radians).

=back

=head1 SCIENTIFIC STATUS

Unvalidated mathematical exploration. Recursive numerical patterns do not
establish tachyon detection, new particle physics, optical gain, time travel, or
safer aircraft guidance. Any navigation use would require independent
verification and safety certification and must not replace approved avionics.

=head1 COPYRIGHT

Copyright 2026 Timothy Dean Firman (attribution to underlying theoretical
manuscripts). Software licensing and distribution rights remain to be decided
by the copyright holder(s) before public release.

=cut
