use strict;
use warnings;
use Test::More;
use lib 'lib';
use Fractalplicitive::Math qw(
    inverse_geometric_sum tetra_wave fractal_time_step aperture_baselines
    echo_response recursive_schedule
);
for my $test (
    [ sub { inverse_geometric_sum(1) }, qr/alpha must be/ ],
    [ sub { fractal_time_step(1,-1,2) }, qr/gamma must be/ ],
    [ sub { tetra_wave(0,[1],[1],[1]) }, qr/exactly four/ ],
    [ sub { aperture_baselines([[1,2]]) }, qr/at least two/ ],
    [ sub { echo_response([1],[{delay=>-1,gain=>1}]) }, qr/integer/ ],
    [ sub { recursive_schedule(0,0,0.5,2) }, qr/initial time step/ ],
) {
    my ($code, $expected) = @$test;
    my $ok = eval { $code->(); 1 };
    ok(!$ok && $@ =~ $expected, 'invalid input rejected');
}
done_testing;
