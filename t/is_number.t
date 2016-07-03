#!perl -T

use strict;
use warnings;

use Test2::Bundle::Extended;
plan 1;

use Test2::Tools::Numeric;

use lib 't';
use TestUtils;


my @tests = (
    [ 0, 'xxx' ] => array {
        event Ok => { pass => 1 }
    },

    #[ 0, 'Flurgle' ] => array {
    #    event Ok => {
    #        pass => 1,
    #        name => 'Flurgle',
    #    },
    #},
);


while ( my ( $args, $expected ) = splice( @tests, 0, 2 ) ) {
    my $args_desc = join( ', ', @{$args} );
    my $desc = "is_number( $args_desc )";
    my $events = intercept { is_number( @{$args} ) };
    is( $events, $expected, $desc );
}


done_testing();

exit 0;
