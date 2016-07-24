#!perl -T

use strict;
use warnings;

use Test2::Bundle::Extended;
plan 3;

use Test2::Tools::Numeric;

use lib 't';
use TestUtils;

imported_ok( 'is_number' );

simple_sub_tester( 'is_number', \&is_number, 1, {
        'zero'           => 0,
        'one'            => 1,
        'negative one'   => -1,
        'two point'      => 2.,
        'two point zero' => 2.0,
        '0E0'            => 0E0,
        'sqrt(2)'        => sqrt(2),
        'six million'    => 6_000_000,
    }
);

simple_sub_tester( 'is_number', \&is_number, 0, {
        'noisy punctuation' => '=1',
        'sign at the end'   => '1-',
        'letters'           => 'abc',
        'empty string'      => '',
        'undef'             => undef,
        'arrayref'          => [],
        'hashref'           => {},
    }
);


done_testing();

exit 0;
