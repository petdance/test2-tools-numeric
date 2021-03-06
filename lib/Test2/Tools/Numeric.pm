package Test2::Tools::Numeric;

use 5.010;
use strict;
use warnings;

use Test2::API qw( context );
use Test2::Tools::Subtest;
use Test2::Tools::ClassicCompare;

use Scalar::Util qw( looks_like_number );

=head1 NAME

Test2::Tools::Numeric - Test functions for common numeric tests

=head1 VERSION

Version 0.01_01

=cut

our $VERSION = '0.01_01';

use base 'Exporter';

our @EXPORT_OK = qw(
    is_number
    is_integer
    is_positive_integer
    is_nonnegative_integer
    cmp_integer_ok
    is_even
    is_odd
);

our @EXPORT = @EXPORT_OK;

=head1 SYNOPSIS

    use Test2::Tools::Numeric;

    my @array = get_widgets();
    is_even( scalar @a, '@array must have an even number of widgets' );

=head1 WHY TEST2::TOOLS::NUMERIC?

Test2::Tools::Numeric is designed to make your code more readable,
because reading English is easier and less prone to
misinterpretation than reading Perl, and less prone to error by
reducing common cut & paste tasks.

Conside these two tests:

    ok( $x % 2 == 0 );
    is( $x % 2, 0 );

What are they doing?  They're testing that C<$x> is an even number.
It's a common expression that most programmers can easily identify.
Most any programmer will see that and think "Aha, it's testing to
see if it's an even number."

Better still to make it explicitly clear, in English, what you're
trying to accomplish:

    is_even( $x );

Test2::Tools::Numeric also does more stringent checking than the
common quick tests that we put in.  These tests will all pass.  You
probably don't want them to.

    for my $x ( undef, 'foo', {}, [] ) {
        ok( $x % 2 == 0 );
    }

Here's another one that will pass, albeit with warnings, even though
it's undoubtedly a mistake:

    my %hash = ( foo => 1, bar => 2, bat => 3 );
    cmp_ok( %hash, '>', 0 );

Why does it pass?  Because the stringification of that hash is "3/8"
and in a numeric context that becomes 3.

Test2::Tools::Numeric is based on the idea that the reader should
be able to tell as much from English as possible without having to
decipher code, and to have extra safety checks that you might not
consider.

=head1 EXPORT

All functions in this module are exported by default.

=head1 NUMERIC SUBROUTINES

=head2 is_number( $n [, $name ] )

Tests that C<$n> is what Perl considers to be a number.

=cut

sub is_number($;$) {
    my $n    = shift;
    my $name = shift;

    my $ok;
    my $ctx = context();

    if ( defined $n ) {
        $ok = looks_like_number( $n );
        $ctx->ok( $ok, $name );
    }
    else {
        $ok = $ctx->ok( 0, $name );
        $ctx->diag( 'undef is not a number' );
    }

    $ctx->release();

    return $ok;
}

=head2 is_integer( $n [, $name ] )

Tests if C<$n> is an integer.

The following are integers:

    1
    -1
    +1
    0E0
    9E14
    -9E14

The following are not:

    string representations of integers
    1.
    1.0
    'abc'
    ''
    undef
    Any reference

=cut

sub is_integer($;$) {
    my $n    = shift;
    my $name = shift;

    my $ok = _looks_like_integer( $n );

    my $ctx = context();
    $ctx->ok( $ok, $name );
    $ctx->release();

    return $ok;
}


=head2 cmp_integer_ok( $got, $op, $expected [, $name ] )

Tests that both C<$got> and C<$expected> are valid integers, and match
the comparator C<$op>.

This is a strengthened version of C<cmp_ok>.  With normal C<cmp_ok>,
you can get back unexpected values that still match, such as:

    cmp_ok( '',    '==', 0 );       # Passes
    cmp_ok( undef, '==', 0 );       # Passes
    cmp_ok( 'abc', '==', 0 );       # Passes
    cmp_ok( 'abc', '==', 'xyz' );   # Passes

These will all throw various warnings if the C<warnings> pragma is on,
but the tests will still pass.

C<cmp_integer_ok> is more stringent and will catch accidental passes.

    cmp_integer_ok( '',    '==', 0 );   # Fails
    cmp_integer_ok( undef, '==', 0 );   # Fails

It also checks that your comparator is valid.

    cmp_integer_ok( 0,     'eq', 0 );   # Fails because 'eq' isn't valid for integers

=cut

my %valid_integer_op = map { $_ => 1 } qw( == != > >= < <= );

sub cmp_integer_ok($$$;$) {
    my $got      = shift;
    my $op       = shift;
    my $expected = shift;
    my $name     = shift;

    my @diags;
    if ( !_looks_like_integer( $got ) ) {
        push( @diags, 'Left-hand operand ' . _stringify($got) . ' is not an integer' );
    }

    if ( !$valid_integer_op{ $op } ) {
        push( @diags, _stringify($op) . ' is not a valid integer operator' );
    }

    if ( !_looks_like_integer( $expected ) ) {
        push( @diags, 'Right-hand operand ' . _stringify($expected) . ' is not an integer' );
    }

    my $ok;

    my $ctx = context();
    if ( @diags ) {
        $ok = $ctx->ok( !@diags, $name, \@diags );
    }
    else {
        $ok = cmp_ok( $got, $op, $expected, $name );
    }
    $ctx->release;

    return $ok;
}


=head2 is_positive_integer( $n [, $name ] )

Verifies that C<$n> is an integer, and greater than zero.

=cut

sub is_positive_integer($;$) {
    my $n    = shift;
    my $name = shift;

    return cmp_integer_ok( $n, '>', 0, $name );
}


=head2 is_nonnegative_integer( $n [, $name ] )

Verifies that C<$n> is an integer, and greater than or equal to zero.

=cut

sub is_nonnegative_integer($;$) {
    my $n    = shift;
    my $name = shift;

    return cmp_integer_ok( $n, '>=', 0, $name );
}


=head2 is_even( $n [, $name ] )

Checks whether the number C<$n> is an integer and is divisible by two.

=cut

sub is_even($;$) {
    my $n    = shift;
    my $name = shift // '';

    return subtest_buffered "is_even( $name )" => sub {
        my $ctx = context();
        my $ok = is_integer( $n );
        if ( $ok ) {
            $ctx->ok( $n % 2 == 0, 'Is it divisible by two?' );
        }

        $ctx->release;
    };
}


=head2 is_odd( $n [, $name ] )

Checks whether the number C<$n> is an integer and is not divisible by two.

=cut

sub is_odd($;$) {
    my $n    = shift;
    my $name = shift // '';

    return subtest_buffered "is_odd( $name )" => sub {
        my $ok = is_integer( $n );
        if ( $ok ) {
            my $ctx = context();
            $ctx->ok( $n % 2 == 1, 'Is it NOT divisible by two?' );
            $ctx->release();
        }
    };
}


sub _looks_like_integer {
    my $n = shift;

    return looks_like_number( $n ) && ($n =~ /^[-+]?\d+(?:E\d+)?$/);
}


sub _stringify {
    my $x = shift;

    return defined($x) ? qq{"$x"} : 'undef';
}



=head1 AUTHOR

Andy Lester, C<< <andy at petdance.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-test2-tools-numeric at rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test2-Tools-Numeric>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test2::Tools::Numeric

You can also look for information at:

=over 4

=item * MetaCPAN

L<http://metacpan.org/release/Test2-Tools-Numeric/>

=item * Search CPAN

L<http://search.cpan.org/dist/Test2-Tools-Numeric/>

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test2-Tools-Numeric>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test2-Tools-Numeric>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test2-Tools-Numeric>

=back

=head1 ACKNOWLEDGEMENTS

Some ideas for tests came from Edmund von der Burg's
L<http://search.cpan.org/dist/Test-Numeric/ Test::Numeric>.

=head1 LICENSE AND COPYRIGHT

Copyright 2016 Andy Lester.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0).

=cut

1; # End of Test2::Tools::Numeric
