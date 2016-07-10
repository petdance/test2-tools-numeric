#!perl -T

use strict;
use warnings;

use Test2::Bundle::Extended;
plan 4;

use Test2::Tools::Numeric;

use lib 't';
use TestUtils;

imported_ok( 'is_number' );


like(
    intercept { is_number( undef, 'failer' ) },
    array {
        fail_events Ok => { pass => 0 };
        end;
    },
    'undef should fail'
);

like(
    intercept { is_number( 14 ) },
    array {
        event Ok => { pass => 1 };
    },
    '14 should pass'
);

like(
    intercept { is_number( 'xxx', 'Manual xxx' ) },
    array {
        fail_events Ok => { pass => 0 };
        end;
    },
    'xxx should fail'
);


done_testing();

exit 0;
