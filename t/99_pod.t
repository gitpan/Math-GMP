#!perl

## Check our Pod, requires Test::Pod
## Also done if available: Test::Pod::Coverage
## Requires TEST_AUTHOR env

use 5.006;
use strict;
use warnings;
use Test::More;
select(($|=1,select(STDERR),$|=1)[1]);

if (!$ENV{TEST_AUTHOR}) {
	plan skip_all => 'Set the environment variable TEST_AUTHOR to enable this test';
}

plan tests => 2;

my $PODVERSION = '0.95';
eval {
	require Test::Pod;
	Test::Pod->import;
};

SKIP: {
	if ($@ or $Test::Pod::VERSION < $PODVERSION) {
		skip ("Test::Pod $PODVERSION is required", 1);
	}
	pod_file_ok ('lib/Math/GMP.pm');
}

## We won't require everyone to have this, so silently move on if not found
my $PODCOVERVERSION = '1.04';
eval {
	require Test::Pod::Coverage;
	Test::Pod::Coverage->import;
};
SKIP: {

	if ($@ or $Test::Pod::Coverage::VERSION < $PODCOVERVERSION) {
		skip ("Test::Pod::Coverage $PODCOVERVERSION is required", 1);
	}

	my $trusted_names  =
		[
		];

	my $t='Math::GMP pod coverage okay';
	pod_coverage_ok ('Math::GMP', {trustme => $trusted_names}, $t);
}
