#!/usr/bin/env perl
use strict;
use warnings;
use JSON::PP;
use lib 'lib';
use Fractalplicitive::Math qw(
    fractal_times recursive_schedule inverse_weights
    aperture_pair_count rotation_states tetra_wave echo_response
);

my $data = {
    original_fractal_time => fractal_times(1,0.5,4),
    FISRARER_schedule     => recursive_schedule(0,1,0.5,4),
    inverse_weights       => inverse_weights(2,4),
    seven_aperture_pairs  => aperture_pair_count(7),
    rotating_arrays       => rotation_states(0,0.2,1.1,0,1,0.8,4),
    tetra_wave_t0         => tetra_wave(0,[1,1,1,1],[100,150,200,300],[0,0,0,0]),
    echo                   => echo_response([1,0,0,0,0],[{delay=>0,gain=>1},{delay=>3,gain=>0.4}]),
    research_status        => 'Unvalidated mathematical model; not flight-control software',
};
print JSON::PP->new->canonical->pretty->encode($data);
