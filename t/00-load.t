#!perl -T
use 5.008001;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Test2::Tools::Numeric' ) || print "Bail out!\n";
}

diag( "Testing Test2::Tools::Numeric $Test2::Tools::Numeric::VERSION, Perl $], $^X" );
