package Math::GMP;

use Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $AUTOLOAD);

use overload 
  '""'  =>   \&stringify,
  '0+'  =>   \&intify,

  '<=>'  =>  \&op_spaceship,
  'cmp'  =>  \&op_cmp,

  '+'   =>   \&op_add,
  '-'   =>   \&op_sub,

  '%'   =>   \&op_mod,
  '**'   =>  \&op_pow,
  '*'   =>   \&op_mul,
  '/'   =>   \&op_div;

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	
);
$VERSION = '0.90';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "& not defined" if $constname eq 'constant';
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
		croak "Your vendor has not defined Math::GMP macro $constname";
	}
    }
    no strict 'refs';
    *$AUTOLOAD = sub () { $val };
    goto &$AUTOLOAD;
}

bootstrap Math::GMP $VERSION;

use strict;
sub import {
  shift;
  return unless @_;
  die "unknown import: @_" unless @_ == 1 and $_[0] eq ':constant';
  overload::constant integer => sub { Math::GMP->new(shift) };
}
  

sub new {
  my $class = shift;
  my $ival = shift;

  $ival =~ s/^\+//;
  $ival =~ s/[ _]//g;
  $ival = 0 if $ival =~ /[^\d\-]/ || !$ival;

  my $ret = Math::GMP::new_from_scalar($ival);

  return $ret;
}

sub DESTROY {
  Math::GMP::destroy($_[0]);
}

sub add {
  croak "add: not enough arguments, two required" unless @_ > 1;

  my $ret = Math::GMP->new(0);
  add_to_self($ret, shift) while @_;

  return $ret;
}

sub stringify {
  return Math::GMP::stringify_gmp($_[0]);
}

sub intify {
  return Math::GMP::intify_gmp($_[0]);
}

sub promote {
  return $_[0] if ref $_[0] eq 'Math::GMP';
  return Math::GMP::new_from_scalar($_[0] || 0);
}

sub gcd {
  return gcd_two(promote(shift), promote(shift));
}

sub op_add {
  return add_two(promote(shift), promote(shift));
}

sub op_sub {
  return sub_two(promote(shift), promote(shift));
}

sub op_mul {
  return mul_two(promote(shift), promote(shift));
}

sub op_div {
  return div_two(promote(shift), promote(shift));
}

sub op_mod {
  return mod_two(promote(shift), promote(shift));
}



sub op_cmp {
  return cmp_two(stringify(promote(shift)), stringify(promote(shift)));
}

sub op_spaceship {
  my $x = cmp_two(promote(shift), promote(shift));
  return $x < 0 ? -1 : $x > 0 ? 1 : 0;
}

sub op_pow {
  my ($m, $n) = @_;
  ($n, $m) = ($m, $n) if $_[2];
  return pow_two(promote($m), int($n));
}

__END__

=head1 NAME

Math::GMP - High speed arbitrary size integer math

=head1 SYNOPSIS

  use Math::GMP;
  my $n = new Math::GMP 2;

  $n = $n ** (256*1024);
  $n = $n - 1;
  print "n is now $n\n";

=head1 DESCRIPTION

Math::GMP is designed to be a drop-in replacement both for Math::BigInt 
and for regular integer arithmetic.  Unlike BigInt, though, Math::GMP uses
the GNU gmp library for all of its calculations, as opposed to straight Perl 
functions.  This results in a speed increase of anywhere from 5 to 30 times.  
The downside is that this module requires a C compiler to install -- a small
tradeoff in most cases.

A Math::GMP object can be used just as a normal numeric scalar would be --
the module overloads the normal arithmetic operators to provide as seamless
an interface as possible.  However, if you need a perfect interface, you can
do the following:

  use Math::GMP qw(:constant);

  $n = 2 ** (256 * 1024);
  print "n is $n\n";

This would fail without the ':constant' since Perl would use normal integers
to compute the 250,000 bit number, and thereby truncate it into 
meaninglessness.

=head1 BUGS

As of version 0.9, Math::GMP is mostly compatible with Math::BigInt.  There
are some slight incompatibilities, such as output of positive numbers not
being prefixed by a '+' sign.  It is planned that the 1.0 release be completely
compatible.

The install process of the gmp library is rather contrived.  This needs fixing
and testing on various platforms.

=head1 AUTHOR

Chip Turner <chip@zfx.com>, based on Math::BigInt by Mark Biggar and Ilya
Zakharevich.

=cut
