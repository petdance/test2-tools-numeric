#!perl -T

use 5.008001;
use strict;
use warnings;

use Test2::Tools::Numeric;

use Test2;
use Test2::Bundle::More;

plan 1;


diag( "Testing Test2::Tools::Numeric $Test2::Tools::Numeric::VERSION with Test2 $Test2::VERSION, Perl $], $^X" );

pass( 'All happy' );
