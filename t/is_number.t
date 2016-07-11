#!perl -T

use strict;
use warnings;

use Test2::Bundle::Extended;
plan 4;

use Test2::Tools::Numeric;

use lib 't';
use TestUtils;

imported_ok( 'is_number' );


my $LINE = __LINE__ + 2;
is(
    intercept { is_number( undef, 'undef is not a number' ) },
    array {
        fail_events Ok => sub {
            call pass => 0;
            call name => 'undef is not a number';
            prop line => $LINE;
            prop file => __FILE__;
        }
    },
    'undef should fail'
);

$LINE = __LINE__ + 2;
is(
    intercept { is_number( 14 ) },
    array {
        event Ok => sub {
            call name => undef;
            prop line => $LINE;
            prop file => __FILE__;
        }
    },
    '14 should pass'
);

$LINE = __LINE__ + 2;
is(
    intercept { is_number( 'xxx', 'Manual xxx' ) },
    array {
        fail_events Ok => sub {
            call pass => 0;
            call name => 'Manual xxx';
            prop line => $LINE;
            prop file => __FILE__;
        }
    },
    'xxx should fail'
);


done_testing();

exit 0;
