use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Fractalplicitive::Math',
    VERSION_FROM => 'lib/Fractalplicitive/Math.pm',
    ABSTRACT     => 'Experimental recursive mathematics from Fractalplicitive research',
    AUTHOR       => 'Timothy Dean Firman (theoretical framework)',
    PREREQ_PM    => {
        'Exporter'     => 0,
        'Math::Complex'=> 0,
        'POSIX'        => 0,
        'Scalar::Util' => 0,
    },
    test => {TESTS => 't/*.t'},
);
