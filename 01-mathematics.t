use strict;
use warnings;
use Test::More;
use Math::Complex qw(Re Im);
use lib 'lib';
use Fractalplicitive::Math qw(
    fractal_time_step fractal_times recursive_schedule
    inverse_geometric_sum inverse_weights photon_inverse_momentum
    fractal_length rest_energy mc3_quantity energy_step displacement_step
);

sub near { abs($_[0]-$_[1]) < ($_[2] || 1e-9) }

ok(near(fractal_time_step(1, 0.5, 1), 1.5), 'original time step');
is_deeply(fractal_times(0,0.5,3),[0,0,0,0], 'original zero initial time is fixed');
my $times = fractal_times(1,0.5,3);
ok(near($times->[-1], 2.109375), 'original time recurrence');
is_deeply(recursive_schedule(0,1,0.5,3),[0,1,1.5,1.75], 'engineering schedule');
ok(near(inverse_geometric_sum(2),2), 'converged geometric factor');
ok(near(inverse_geometric_sum(2,3),1.75), 'finite geometric factor');
my $weights = inverse_weights(2,4);
ok(near((eval join '+', @$weights),1), 'weights sum to one');
ok(near($weights->[0],8/15), 'first normalized weight');
ok(near(photon_inverse_momentum(3,2),6), 'numeric inverse momentum');
ok(near(fractal_length(16,0.5,3),2), 'fractal length scaling');
is(rest_energy(2,3),18,'mc^2');
is(mc3_quantity(2,3),54,'mc^3 numeric quantity');
my $energy = energy_step(1,2,0,1);
ok(near(Re($energy),2.5) && near(Im($energy),0), 'complex energy recurrence with alpha=0');
my $space = displacement_step(2,0,2,0,1);
ok(near(Re($space),5) && near(Im($space),0), 'complex displacement recurrence with alpha=0');
done_testing;
