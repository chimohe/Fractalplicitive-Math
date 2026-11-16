use strict;
use warnings;
use Test::More;
use lib 'lib';
use Fractalplicitive::Math qw(
    tetra_wave echo_response aperture_pair_count aperture_baselines rotation_states
);

sub near { abs($_[0]-$_[1]) < ($_[2] || 1e-9) }
ok(near(tetra_wave(0,[(1)x4],[1,2,3,4],[(0)x4]),4), 'four-mode waveform at t=0');
is_deeply(echo_response([1,0,0,0], [{delay=>0,gain=>1},{delay=>2,gain=>0.5}]), [1,0,0.5,0], 'discrete echo taps');
is(aperture_pair_count(7),21,'7 apertures make 21 possible pairs');
my $b = aperture_baselines([[0,0],[3,4],[0,1]]);
is(scalar(@$b),3,'three baselines from three apertures');
ok(near($b->[0]{length},5),'baseline Euclidean distance');
my $r = rotation_states(0,1,1,0,1,0.5,2);
is(scalar(@$r),3,'initial state + two rotations');
ok(near($r->[-1]{time},1.5),'recursive time accumulation');
ok(near($r->[-1]{theta_rad},1.5),'recursive angular rotation');
done_testing;
