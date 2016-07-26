#!perl -T

use strict;
use warnings;

use Test2::Bundle::Extended;
plan 3;

use Test2::Tools::Numeric;

use lib 't';
use TestUtils;

imported_ok( 'is_integer' );

simple_sub_tester( 'is_integer', \&is_integer, 1, {
        'zero'                 => 0,
        'one'                  => 1,
        'negative one'         => -1,
        '0 but true'           => 0E0,
        'postive exponential'  => 9E14,
        'negative exponential' => -9E14,
    }
);

simple_sub_tester( 'is_integer', \&is_integer, 0, {
        'decimal'           => '1.',
        'decimal.0'         => '1.0',
        'noisy punctuation' => '=1',
        'sign at the end'   => '1-',
        'letters'           => 'abc',
        'empty string'      => '',
        'undef'             => undef,
        'hashref'           => {},
    }
);


done_testing();

exit 0;
