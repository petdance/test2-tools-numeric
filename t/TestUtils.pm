package TestUtils;

use base 'Exporter';

our @EXPORT_OK = qw(
    simple_sub_tester
    tests_pass_fail
    dump_events
);

our @EXPORT = @EXPORT_OK;

use Test2::API qw( intercept );
use Test2::Bundle::Extended;

sub tests_pass_fail {
    my $sub     = shift;
    my $passers = shift;
    my $failers = shift;

    while ( my ($desc,$val) = each %{$passers} ) {
        my @args = ref($val) eq 'ARRAY' ? @{$val} : ($val);
        my $events = intercept { $sub->( @args ) };

        my $fails_somewhere = grep { $_->causes_fail } @{$events};
        ok( !$fails_somewhere, "Should pass: $desc" );
    }

    while ( my ($desc,$val) = each %{$failers} ) {
        my @args = ref($val) eq 'ARRAY' ? @{$val} : ($val);
        my $events = intercept { $sub->( @args ) };

        my $fails_somewhere = grep { $_->causes_fail } @{$events};
        ok( $fails_somewhere, "Should fail: $desc" );
    }
}


sub dump_events {
    my $events = shift;

    diag scalar @{$events} . ' events';
    for my $event ( @{$events} ) {
        diag $event->summary;
    }
}


sub simple_sub_tester {
    my $sub_name    = shift;
    my $sub         = shift;
    my $should_pass = shift;
    my $tests       = shift;

    return subtest "simple_sub_tester( $sub_name, should_pass=$should_pass )" => sub {
        plan 2 * keys %{$tests};

        while ( my ( $value_desc, $value ) = each %{$tests} ) {
            for my $with_message ( 0..1 ) {
                my $name;
                my @args;

                if ( $with_message ) {
                    $name = 'Test name';
                    @args = ($value, $name);
                }
                else {
                    $name = undef;
                    @args = ($value);
                }

                my $LINE = __LINE__ + 1;
                my $actual_events = intercept { $sub->( @args ) };

                my $expected_events;
                if ( $should_pass ) {
                    $expected_events = array {
                        event Ok => sub {
                            call pass => 1;
                            call name => $name;
                            prop line => $LINE;
                            prop file => __FILE__;
                        }
                    }
                }
                else {
                    $expected_events = array {
                        fail_events Ok => sub {
                            call pass => 0;
                            call name => $name;
                            prop line => $LINE;
                            prop file => __FILE__;
                        }
                    }
                }
                is(
                    $actual_events,
                    $expected_events,
                    "$value_desc, with_message=$with_message"
                );
            }
        }
    };
}


1;
