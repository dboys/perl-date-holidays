package Test::Class::Date::Holidays;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More; # done_testing
use Test::Fatal qw(dies_ok);
use Env qw($TEST_VERBOSE);

#run prior and once per suite
sub startup : Test(startup => 1) {

    # Testing compilation of component
    use_ok('Date::Holidays');
}

sub constructor : Test(5) {

    # Constructor requires country code so this test relies on
    # Date::Holidays::DK
    SKIP: {
        eval { require Date::Holidays::DK };
        skip "Date::Holidays::DK not installed", 5 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'DK', nocheck => 1 ) );

        isa_ok( $dh, 'Date::Holidays', 'checking wrapper object' );

        can_ok( $dh, qw(new), 'new' );

        can_ok( $dh, qw(holidays), 'holidays' );

        can_ok( $dh, qw(is_holiday), 'is_holiday' );
    }
}

sub _fetch : Test(2) {

    # Constructor requires country code so this test relies on
    # Date::Holidays::DK
    SKIP: {
        eval { require Date::Holidays::DK };
        skip "Date::Holidays::DK not installed", 2 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'DK' ) );

        can_ok( $dh, '_fetch' );
    }
}

sub _load : Test(1) {

    #Testing load with something from own distribution
    ok(my $mod = Date::Holidays->_load('Date::Holidays::Adapter'));
}

sub is_holiday_dt : Test(3) {
    SKIP: {
        eval { require Date::Holidays::DK };
        skip "Date::Holidays::DK not installed", 3 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'dk' ) );

        my $dt = DateTime->new(
            year  => 2004,
            month => 12,
            day   => 24,
        );

        #test 2
        ok( $dh->is_holiday_dt($dt) );

        $dt = DateTime->new(
            year  => 2004,
            month => 1,
            day   => 15,
        );

        ok( !$dh->is_holiday_dt($dt) );
    }
}

sub holidays_dt : Test(17) {
    SKIP: {
        eval { require Date::Holidays::DK };
        skip "Date::Holidays::DK not installed", 17 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'dk' ) );

        my $dt = DateTime->new(
            year  => 2004,
            month => 12,
            day   => 24,
        );

        ok( my $hashref = $dh->holidays_dt( year => 2004 ) );

        is( keys %{$hashref}, 14 );

        foreach my $dt ( keys %{$hashref} ) {
            is( ref $hashref->{$dt}, 'DateTime' );
        }
    }
}

sub test_at : Test(5) {
    SKIP: {
        eval { require Date::Holidays::AT };
        skip "Date::Holidays::AT not installed", 5 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'at' ),
            'Testing Date::Holidays::AT' );

        ok( $dh->holidays( YEAR => 2017 ),
            'Testing holidays with argument for Date::Holidays::AT' );

        my $holidays_hashref;

        ok( !$holidays_hashref->{'at'},
            'Checking for Austrian first day of year' );

        ok(! Date::Holidays::AT->can('is_holiday'));
        can_ok('Date::Holidays::AT', qw(holidays));
    }
}

sub test_au : Test(7) {
    SKIP: {
        eval { require Date::Holidays::AU };
        skip "Date::Holidays::AU not installed", 7 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'au' ),
            'Testing Date::Holidays::AU' );

        ok( $dh->holidays( year => 2006 ),
            'Testing holidays for Date::Holidays::AU' );

        ok( $dh->holidays(
                year  => 2006,
                state => 'VIC',
            ),
            'Testing holidays for Date::Holidays::AU'
        );

        my $holidays_hashref;

        ok( $holidays_hashref->{'au'},
            'Checking for Australian christmas' );

        can_ok('Date::Holidays::AU', qw(holidays is_holiday));

        ok(my $au = Date::Holidays->new(countrycode => 'au'));

        ok($au->is_holiday(
            day   => 9,
            month => 3,
            year  => 2015,
            state => 'TAS',
        ), 'Asserting 8 hour day in Tasmania, Australia');
    }
}

sub test_br : Test(4) {
    SKIP: {
        eval { require Date::Holidays::BR };
        skip "Date::Holidays::BR not installed", 4 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'br' ),
            'Testing Date::Holidays::BR' );

        ok( $dh->holidays( year => 2004 ),
            'Testing holidays for Date::Holidays::BR' );

        my $holidays_hashref;

        ok( $holidays_hashref->{'br'},
            'Checking for Brazillian first day of year' );

        can_ok('Date::Holidays::BR', qw(holidays is_holiday));
    }
}

sub test_by : Test(5) {
    SKIP: {
        eval { require Date::Holidays::BY };
        skip "Date::Holidays::BY not installed", 5 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'by' ),
            'Testing Date::Holidays::BY' );

        ok( $dh->holidays( year => 2017 ),
            'Testing holidays with argument for Date::Holidays::BY' );

        my $holidays_hashref = Date::Holidays->is_holiday(
            year  => 2017,
            month => 1,
            day   => 1,
            countries => [ 'by' ],
        );

        ok( $holidays_hashref->{by}, 'Checking for Belarys New Year' );

        ok( Date::Holidays::BY->can('holidays') );
        ok( Date::Holidays::BY->can('is_holiday') );
    }
}

sub test_ca : Test(2) {
    SKIP: {
        eval { require Date::Holidays::CA };
        skip "Date::Holidays::CA not installed", 2 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'ca' ),
            'Testing Date::Holidays::CA' );

        ok( $dh->holidays( year => 2004 ),
            'Testing holidays for Date::Holidays::CA' );
    }
}

sub test_cn : Test(3) {
    SKIP: {
        eval { require Date::Holidays::CN };
        skip "Date::Holidays::CN not installed", 3 if $@;

        my $holidays_hashref;

        ok( $holidays_hashref->{'cn'},
            'Checking for Chinese first day of year' );

        ok(! Date::Holidays::CN->can('holidays'));
        ok(! Date::Holidays::CN->can('is_holiday'));
    }
}

sub test_de : Test(3) {
    SKIP: {
        eval { require Date::Holidays::DE };
        skip "Date::Holidays::DE not installed", 3 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'de' ),
            'Testing Date::Holidays::DE' );

        ok( $dh->holidays(),
            'Testing holidays with no arguments for Date::Holidays::DE' );

        ok( $dh->holidays( year => 2006 ),
            'Testing holidays with argument for Date::Holidays::DE' );
    }
}

sub test_dk : Test(2) {
    SKIP: {
        eval { require Date::Holidays::DK };
        skip "Date::Holidays::DK not installed", 2 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'dk' ),
            'Testing Date::Holidays::DK' );

        ok( $dh->holidays( year => 2004 ),
            'Testing holidays for Date::Holidays::DK' );
    }
}

sub test_es : Test(5) {
    SKIP: {
        eval { require Date::Holidays::ES };
        skip "Date::Holidays::ES not installed", 5 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'es' ),
            'Testing Date::Holidays::ES' );

        ok( $dh->holidays( year => 2006 ),
            'Testing holidays with argument for Date::Holidays::ES' );

        my $holidays_hashref;

        ok( $holidays_hashref->{'es'}, 'Checking for Spanish christmas' );

        can_ok('Date::Holidays::ES', qw(holidays is_holiday));
    }
}

sub test_fr : Test(6) {
    SKIP: {
        eval { require Date::Holidays::FR };
        skip "Date::Holidays::FR not installed", 6 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'fr' ),
            'Testing Date::Holidays::FR' );

        dies_ok { $dh->holidays(); }
            'Testing holidays with no arguments for Date::Holidays::FR';

        dies_ok { $dh->holidays( year => 2017 ); }
            'Testing holidays with argument for Date::Holidays::FR';

        my $holidays_hashref;

        ok( $holidays_hashref->{'fr'}, 'Checking for French christmas' );

        ok(! Date::Holidays::FR->can('holidays'));
        ok(! Date::Holidays::FR->can('is_holiday'));
    }
}

sub test_gb : Test(10) {
    SKIP: {
        eval { require Date::Holidays::GB };
        skip "Date::Holidays::GB not installed", 10 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'gb' ),
            'Testing Date::Holidays::GB' );

        ok( $dh->holidays(),
            'Testing holidays with no arguments for Date::Holidays::GB' );

        ok( $dh->holidays( year => 2014 ),
            'Testing holidays with argument for Date::Holidays::GB' );

        my $holidays_hashref;

        ok( $holidays_hashref->{'gb'}, 'Checking for English holiday' );

        can_ok('Date::Holidays::GB', qw(holidays is_holiday));

        ok( my $holidays_hashref_sct = Date::Holidays::GB::holidays(year => 2014, regions => ['SCT']));

        ok( my $holidays_hashref_eaw = Date::Holidays::GB::holidays(year => 2014, regions => ['EAW']));

        ok( keys %{$holidays_hashref_eaw} != keys %{$holidays_hashref_sct});

        ok(my $gb = Date::Holidays->new(countrycode => 'gb'));

        ok($gb->is_holiday(
            day   => 17,
            month => 3,
            year  => 2015,
            region => 'NIR',
        ), 'Asserting St Patrick’s Day in Northern Ireland');
    }
}

sub test_kr : Test(6) {
    SKIP: {
        eval { require Date::Holidays::KR };
        skip "Date::Holidays::KR not installed", 6 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'kr' ),
            'Testing Date::Holidays::KR' );

        dies_ok { $dh->holidays(); }
            'Testing holidays with no arguments for Date::Holidays::KR';

        dies_ok { $dh->holidays( year => 2014 ) }
            'Testing holidays with argument for Date::Holidays::KR';

        my $holidays_hashref;

        ok(! $holidays_hashref->{'kr'}, 'Checking for Korean holiday' );

        ok(Date::Holidays::KR->can('holidays'));
        ok(Date::Holidays::KR->can('is_holiday'));
    }
}

sub test_no : Test(4) {
    SKIP: {
        eval { require Date::Holidays::NO };
        skip "Date::Holidays::NO not installed", 4 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'no' ),
            'Testing Date::Holidays::NO' );

        ok( $dh->holidays( year => 2004 ),
            'Testing holidays for Date::Holidays::NO' );

        my $holidays_hashref;

        ok( $holidays_hashref->{'no'}, 'Checking for Norwegian christmas' );

        can_ok('Date::Holidays::NO', qw(holidays is_holiday));
    }
}

sub test_nz : Test(5) {
    SKIP: {
        eval { require Date::Holidays::NZ };
        skip "Date::Holidays::NZ not installed", 5 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'nz' ),
            'Testing Date::Holidays::NZ' );

        ok( $dh->holidays( year => 2004 ),
            'Testing holidays for Date::Holidays::NZ' );

        my $holidays_hashref;

        ok( $holidays_hashref->{'nz'}, 'Checking for New Zealandian christmas' );

        ok(! Date::Holidays::NZ->can('holidays'));
        ok(! Date::Holidays::NZ->can('is_holiday'));
    }
}

sub test_pl : Test(6) {
    SKIP: {
        eval { require Date::Holidays::PL };
        skip "Date::Holidays::PL not installed", 6 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'pl' ),
            'Testing Date::Holidays::PL');

        dies_ok { $dh->holidays() }
            'Testing holidays for Date::Holidays::PL';

        dies_ok { $dh->holidays( year => 2004 ) }
            'Testing holidays for Date::Holidays::PL';

        my $holidays_hashref;

        ok( $holidays_hashref->{'pl'},
            'Checking for Polish first day of year' );

        ok(Date::Holidays::PL->can('is_holiday'));
        ok(Date::Holidays::PL->can('holidays'));
    }
}

sub test_pt : Test(6) {
    SKIP: {
        eval { require Date::Holidays::PT };
        skip "Date::Holidays::PT not installed", 6 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'pt' ),
            'Testing Date::Holidays::PT' );

        ok( $dh->holidays( year => 2005 ),
            'Testing holidays for Date::Holidays::PT' );

        my $holidays_hashref;

        ok( $holidays_hashref->{'pt'},
            'Checking for Portuguese first day of year' );

        can_ok('Date::Holidays::PT', qw(holidays is_holiday));

        ok( $holidays_hashref->{'pt'},
            'Checking for Portuguese first day of year' );

        can_ok('Date::Holidays::PT', qw(holidays is_holiday));
    }
}

sub test_ru : Test(5) {
    SKIP: {
        eval { require Date::Holidays::RU };
        skip "Date::Holidays::RU not installed", 5 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'ru' ),
            'Testing Date::Holidays::RU' );

        ok( $dh->holidays( year => 2014 ),
            'Testing holidays with argument for Date::Holidays::RU' );

        my $holidays_hashref = Date::Holidays->is_holiday(
            year  => 2015,
            month => 1,
            day   => 7,
            countries => [ 'ru' ],
        );

        ok( $holidays_hashref->{ru}, 'Checking for Russian christmas' );

        ok( Date::Holidays::RU->can('holidays') );
        ok( Date::Holidays::RU->can('is_holiday') );
    }
}

sub test_sk : Test(3) {
    SKIP: {
        eval { require Date::Holidays::SK };
        skip "Date::Holidays::SK not installed", 3 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'sk' ),
            'Testing Date::Holidays::SK' );

        ok( $dh->holidays(),
            'Testing holidays without argument for Date::Holidays::SK' );

        ok( $dh->holidays( year => 2014 ),
            'Testing holidays with argument for Date::Holidays::SK' );
    }
}

# TODO: Get UK under control
# SKIP: {
#     eval { require Date::Holidays::UK };
#     skip "Date::Holidays::UK not installed", 3 if $@;

#     ok( $dh = Date::Holidays->new( countrycode => 'uk' ),
#         'Testing Date::Holidays::UK' );

#     use Data::Dumper;
#     print STDERR Dumper $dh;

#     dies_ok { $dh->holidays() }
#         'Testing holidays without argument for Date::Holidays::UK';

#     dies_ok { $dh->holidays( year => 2014 ) }
#         'Testing holidays with argument for Date::Holidays::UK';
# }

sub test_jp : Test(3) {
    SKIP: {
        eval { require Date::Japanese::Holiday };
        skip "Date::Japanese::Holiday not installed", 3 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'jp' ),
            'Testing Date::Japanese::Holiday' );

        dies_ok { $dh->holidays() }
            'Testing holidays without argument for Date::Japanese::Holiday';

        dies_ok { $dh->holidays( year => 2014 ) }
            'Testing holidays with argument for Date::Japanese::Holiday';
    }
}

sub test_kz : Test(5) {
    SKIP: {
        eval { require Date::Holidays::KZ };
        skip "Date::Holidays::KZ not installed", 5 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'kz' ),
            'Testing Date::Holidays::KZ' );

        ok( $dh->holidays( year => 2018 ),
            'Testing holidays with argument for Date::Holidays::KZ' );

        my $holidays_hashref = Date::Holidays->is_holiday(
            year  => 2018,
            month => 1,
            day   => 2,
            countries => [ 'kz' ],
        );

        ok( $holidays_hashref->{kz}, 'Checking for Kazakhstan New Year' );

        ok( Date::Holidays::KZ->can('holidays') );
        ok( Date::Holidays::KZ->can('is_holiday') );
    }
}

sub test_us : Test(3) {
    SKIP: {
        eval { require Date::Holidays::USFederal };
        skip "Date::Holidays::USFederal not installed", 3 if $@;

        ok( my $dh = Date::Holidays->new( countrycode => 'USFederal', nocheck => 1 ),
            'Testing Date::Holidays::USFederal' );

        dies_ok { $dh->holidays() }
            'Testing holidays without argument for Date::Japanese::Holiday';

        my $holidays_hashref = Date::Holidays->is_holiday(
            year  => 2018,
            month => 1,
            day   => 1,
            countries => [ 'USFederal' ],
        );

        ok( $holidays_hashref->{USFederal}, 'Checking for US Federal New Year' );
    }
}

sub test_norway_and_denmark_combined : Test(6) {
    SKIP: {
        eval { load Date::Holidays::DK };
        skip "Date::Holidays::DK not installed", 6 if ($@);

        eval { load Date::Holidays::NO };
        skip "Date::Holidays::NO not installed", 6 if ($@);

        my $dh = Date::Holidays->new( countrycode => 'dk' );

        isa_ok( $dh, 'Date::Holidays', 'Testing Date::Holidays object' );

        ok( $dh->is_holiday(
                year  => 2004,
                month => 12,
                day   => 25
            ),
            'Testing whether 1. christmas day is a holiday in DK'
        );

        my $holidays_hashref;

        ok( $holidays_hashref = $dh->is_holiday(
                year      => 2004,
                month     => 12,
                day       => 25,
                countries => [ 'no', 'dk' ],
            ),
            'Testing whether 1. christmas day is a holiday in NO and DK'
        );

        is( keys %{$holidays_hashref},
            2, 'Testing to see if we got two definitions' );

        ok( $holidays_hashref->{'dk'}, 'Testing whether DK is set' );
        ok( $holidays_hashref->{'no'}, 'Testing whether NO is set' );
    }
}

sub test_without_object : Test(1) {

    my $holidays_hashref;

    ok( $holidays_hashref = Date::Holidays->is_holiday(
            year  => 2014,
            month => 12,
            day   => 25,
        ),
        'Testing is_holiday called without an object'
    );
}

1;
