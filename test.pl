#!/usr/bin/perl -w
use Math::BigInt;
use Math::GMP;

use Benchmark;

timethese(100,
	  { 'gmp', 'test_gmp',
	    'bi', 'test_bi'
	  });

sub test_gmp {
  my ($m, $n, $t);
  $m = new Math::GMP(1_000_000);
  $n = new Math::GMP(1_234_000);
  $t = new Math::GMP(2);

  my $i = 50;
  $m = ($t *= 20) * $m * $n / 3 while $i--;
#  print "final gmp m: $m\n";
}

sub test_bi {
  my ($m, $n, $t);
  $m = new Math::BigInt(1_000_000);
  $n = new Math::BigInt(1_234_000);
  $t = new Math::BigInt(2);

  my $i = 50;
  $m = ($t *= 20) * $m * $n / 3 while $i--;
#  print "final bi m: $m\n";
}
