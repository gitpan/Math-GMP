use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

my @paths = qw(/bin /usr/bin /usr/local/bin);
my $tar = (grep { -x "$_/tar" } @paths)[0] . "/tar";
my $gzip = (grep { -x "$_/gzip" } @paths)[0] . "/gzip";

my $cmd = "$gzip -dc gmp-2.0.2.tar.gz | $tar xf -";
system $cmd unless -d 'gmp-2.0.2';
die "tar extraction of gmp-2.0.2.tar.gz failed" unless -d 'gmp-2.0.2';

chdir 'gmp-2.0.2';
system "./configure --prefix=../gmp && make && make install";
chdir '..';

WriteMakefile(
    'NAME'	=> 'Math::GMP',
    'VERSION_FROM' => 'GMP.pm', # finds $VERSION
    'LIBS'	=> ['-Lgmp/lib -lgmp'],   # e.g., '-lm' 
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '-Igmp/include',     # e.g., '-I/usr/include/other' 
);
