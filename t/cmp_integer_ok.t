#!perl -T

use strict;
use warnings;

use Test2::Bundle::Extended;
plan 2;

use Test2::Tools::Numeric;

use lib 't';
use TestUtils;

use Test2::Tools::EventDumper;

imported_ok( 'cmp_integer_ok' );

my $sub = \&cmp_integer_ok;
my $actual_events = intercept { $sub->( 7, '>', '6', 'Foo' ) };





my $LINE = __LINE__ + 3;
is( $actual_events, array {
        event Ok => sub {
            call name => 'Foo';
            call pass => 1;
            call effective_pass => 1;

            prop file => __FILE__;
            prop line => 19;
        };
        end();
    }
);

done_testing();

exit 0;
