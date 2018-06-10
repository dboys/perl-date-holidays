package Date::Holidays::Adapter::ES;

use strict;
use warnings;

use base 'Date::Holidays::Adapter';
use Date::Holidays::CA_ES;

use vars qw($VERSION);

$VERSION = '1.12';

sub holidays {
    my ($self, %params) = @_;

    my $dh = $self->{_adaptee}->new();

    my $holidays_es_hashref = {};
    my $holidays_ca_es_hashref = {};

    if ($dh) {
        $holidays_es_hashref = $dh->holidays(year => $params{year});

        if ($params{region} and $params{region} eq 'ca') {
            my $dh_ca_es = Date::Holidays::CA_ES->new();
            $holidays_ca_es_hashref = $dh_ca_es->holidays(year => $params{year});
        }
    } else {
        return;
    }

    foreach my $key (keys %{$holidays_ca_es_hashref}) {
        $holidays_es_hashref->{$key} = $holidays_ca_es_hashref->{$key};
    }

    return $holidays_es_hashref;
}

sub is_holiday {
    my ($self, %params) = @_;

    my $dh = $self->{_adaptee}->new();

    if ($dh) {
        return $dh->is_holiday(year => $params{'year'}, month => $params{'month'}, day => $params{'day'});
    } else {
        return '';
    }
}

1;

__END__

=pod

=head1 NAME

Date::Holidays::Adapter::ES - an adapter class for Date::Holidays::ES

=head1 VERSION

This POD describes version 1.12 of Date::Holidays::Adapter::ES

=head1 DESCRIPTION

The is the SUPER adapter class. All of the adapters in the distribution of
Date::Holidays are subclasses of this particular class. L<Date::Holidays>

=head1 SUBROUTINES/METHODS

=head2 new

The constructor is inherited from L<Date::Holidays::Adapter>

=head2 is_holiday

The B<holidays> method, takes 3 named arguments, B<year>, B<month> and B<day>

Returns an indication of whether the day is a holiday in the calendar of the
country referenced by B<countrycode> in the call to the constructor B<new>.

=head2 holidays

The B<holidays> method, takes a single named argument, B<year>

Returns a reference to a hash holding the calendar of the country referenced by
B<countrycode> in the call to the constructor B<new>.

The calendar will spand for a year and the keys consist of B<month> and B<day>
concatenated.

=head1 DIAGNOSTICS

Please refer to DIAGNOSTICS in L<Date::Holidays>

=head1 DEPENDENCIES

=over

=item * L<Date::Holidays::ES>

=item * L<Date::Holidays::CA_ES>

=item * L<Date::Holidays::Adapter>

=back

=head1 INCOMPATIBILITIES

Please refer to INCOMPATIBILITIES in L<Date::Holidays>

=head1 BUGS AND LIMITATIONS

Please refer to BUGS AND LIMITATIONS in L<Date::Holidays>

=head1 BUG REPORTING

Please refer to BUG REPORTING in L<Date::Holidays>

=head1 AUTHOR

Jonas B. Nielsen, (jonasbn) - C<< <jonasbn@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

L<Date::Holidays> and related modules are (C) by Jonas B. Nielsen, (jonasbn)
2004-2018

Date-Holidays and related modules are released under the Artistic License 2.0

=cut
