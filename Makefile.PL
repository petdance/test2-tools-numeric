use 5.008001;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Test2::Tools::Numeric',
    AUTHOR           => q{Andy Lester <andy@petdance.com>},
    VERSION_FROM     => 'lib/Test2/Tools/Numeric.pm',
    ABSTRACT_FROM    => 'lib/Test2/Tools/Numeric.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.008001,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test2::Bundle::Extended' => 0,
    },
    PREREQ_PM => {
        'Test2::API'                   => 0,
        'Test2::Tools::Subtest'        => 0,
        'Test2::Tools::ClassicCompare' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Test2-Tools-Numeric-*' },
);
