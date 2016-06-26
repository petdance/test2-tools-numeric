#!perl -T

use strict;
use warnings;
use Carp::Always;

use Test2::Bundle::Extended;
plan 5;

use Test2::Tools::Numeric;

use lib 't';
use TestUtils;


#    cmp_integer_ok
#    is_even
#    is_odd


subtest is_number => sub {
    my %passers = (
        'zero'           => 0,
        'one'            => 1,
        'negative one'   => -1,
        'two point'      => 2.,
        'two point zero' => 2.0,
        '0E0'            => 0E0,
        'sqrt(2)'        => sqrt(2),
        'six million'    => 6_000_000,
    );

    my %failers = (
        'noisy punctuation' => '=1',
        'sign at the end'   => '1-',
        'letters'           => 'abc',
        'empty string'      => '',
        'undef'             => undef,
        'arrayref'          => [],
        'hashref'           => {},
    );

    tests_pass_fail( \&is_number, \%passers, \%failers );
};


subtest is_integer => sub {
    my %passers = (
        'zero'                 => 0,
        'one'                  => 1,
        'negative one'         => -1,
        '0 but true'           => 0E0,
        'postive exponential'  => 9E14,
        'negative exponential' => -9E14,
    );

    my %failers = (
        'decimal'           => '1.',
        'decimal.0'         => '1.0',
        'noisy punctuation' => '=1',
        'sign at the end'   => '1-',
        'letters'           => 'abc',
        'empty string'      => '',
        'undef'             => undef,
        'hashref'           => {},
    );

    tests_pass_fail( \&is_integer, \%passers, \%failers );
};


subtest is_positive_integer => sub {
    my %passers = (
        'one'          => 1,
        'big exponent' => 9E14,
    );

    my %failers = (
        'zero'              => 0,
        'negative 1'        => -1,
        '0E0'               => 0E0,
        'decimal'           => '1.',
        'decimal.0'         => '1.0',
        'decimal.999999'    => '1.999999',
        'noisy punctuation' => '=1',
        'sign at the end'   => '1-',
        'letters'           => 'abc',
        'empty string'      => '',
        'undef'             => undef,
        'hashref'           => {},
    );

    tests_pass_fail( \&is_positive_integer, \%passers, \%failers );
};


subtest is_nonnegative_integer => sub {
    my %passers = (
        'zero'          => 0,
        'zero but true' => 0E0,
        'one'           => 1,
        'six million'   => 6_000_000,
        'big exponent'  => 9E14,
    );

    my %failers = (
        'negative 1'        => -1,
        'decimal'           => '1.',
        'decimal.0'         => '1.0',
        'noisy punctuation' => '=1',
        'sign at the end'   => '1-',
        'letters'           => 'abc',
        'empty string'      => '',
        'undef'             => undef,
        'hashref'           => {},
    );

    tests_pass_fail( \&is_nonnegative_integer, \%passers, \%failers );
};


subtest cmp_integer_ok => sub {
    my %passers = (
        'equal'     => [ 0, '==', 0 ],
        'not equal' => [ -14, '!=', 14 ],
        'gt'        => [ 15, '>', 12 ],
        'lt'        => [ 2112, '<', 5150 ],
        'gte'       => [ 2112, '>=', 2112 ],
        'lte'       => [ 5150, '<=', 5150 ],
    );

    my %failers = (
        'equal'     => [ 1, '==', 0 ],
        'not equal' => [ 14, '!=', 14 ],
        'gt'        => [ 12, '>', 15 ],
        'lt'        => [ 2112, '<', 2112 ],
        'gte'       => [ 2112, '>=', 5150 ],
        'lte'       => [ 5150, '<=', 2112 ],

        # Now some non-integers that would evaluate to zero but are still not integers.
        'Cannot use string comparators' => [ 0, 'eq', 0 ],
        'undefs are not =='             => [ undef, '==', undef ],
        'undefs are not eq'             => [ undef, 'eq', undef ],
        'Empty strings are not =='      => [ '', '==', '' ],
        'Empty strings are not eq'      => [ '', 'eq', '' ],
        'Strings are not =='            => [ 'abc', '==', 'abc' ],
        'Strings are not eq'            => [ 'abc', 'eq', 'abc' ],
        'Hashrefs are not =='           => [ {}, '==', {} ],
        'Hashrefs are not eq'           => [ {}, 'eq', {} ],
    );

    tests_pass_fail( \&cmp_integer_ok, \%passers, \%failers );
};

done_testing();

exit 0;
