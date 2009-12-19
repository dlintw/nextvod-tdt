#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use IO::File;
use Pod::Usage;

my $image;
my $operation;
my %parts = ();
my $rootsize = 0;
my $datasize = 0;

GetOptions
(
  'help' => sub { pod2usage ( 1 ); },
  'man' => sub { pod2usage ( -exitstatus => 0, -verbose => 2 ); },
  'image|i=s' => \$image,
  'operation|oper|o=s' => \$operation,
  'part=s' => \%parts,
  'rootsize|r=s' => \$rootsize,
  'datasize|d=s' => \$datasize,
);

#overall size:                fc0000 (16MB - 2*128kB)
#overall size minus app size: ac0000
my %partdef =
(
  0 => [ "kernel", 0,     0x1c0000 ],
  1 => [ "conf", 0x1c0000, 0xa0000 ],
  2 => [ "root", 0x260000, 0x240000 ],
  3 => [ "app",  0x4a0000, 0x600000 ],
  4 => [ "eme",  0xaa0000, 0x120000 ],
  5 => [ "data", 0xbc0000, 0x400000 ],
);
# cat /proc/mtd 
#N dev:  offset     size   erasesize  name
#  mtd0: 00000000 00020000 00010000 "Boot firmware :        0xA000.0000-0xA001.FFFF"
#0:mtd1:          001c0000 00010000 "Kernel -               0xA004.0000-0xA01F.FFFF"
#1:mtd2:          000a0000 00010000 "Config FS -            0xA020.0000-0xA029.FFFF"
#2:mtd3:          00240000 00010000 "Root FS-               0xA02A.0000-0xA04D.FFFF"
#3:mtd4:          00600000 00010000 "APP_Modules            0xA04E.0000-0xA0AD.FFFF"
#4:mtd5:          00120000 00010000 "EmergencyRoot          0xA0AE.0000-0xA0BF.FFFF"
#5:mtd6:          00400000 00010000 "OtherData              0xA0C0.0000-0xA0FF.FFFF"
#  mtd7:          00020000 00010000 "BootConfiguration      0xA002.0000-0xA003.FFFF"

#dbox2
#my %partdef =
#(
#  0 => [ "ppcboot", 0,     0x20000 ],
#  1 => [ "root", 0x20000, 0x660000 ],
#  2 => [ "var", 0x680000, 0x160000 ],
#);

sub part_read
{
  my $in = shift;
  my $file = shift;
  my $begin = shift;
  my $size = shift;

  my $out = IO::File -> new ( $file, O_CREAT | O_EXCL | O_WRONLY ) or die $!;

  $in -> seek ( $begin, SEEK_SET ) or die $!;

  my $buf;

  my $temp = $size;
  while ( $temp > 4096 )
  {
    $in -> sysread ( $buf, 4096 );
    $out -> syswrite ( $buf, 4096 );
    $temp -= 4096;
  }

  $in -> sysread ( $buf, $temp );
  $out -> syswrite ( $buf, $temp );
}

sub part_write
{
  my $out = shift;
  my $file = shift;
  my $begin = shift;
  my $size = shift;

  my $in = IO::File -> new ( $file, O_RDONLY ) or die $!;

  $in -> seek ( 0, SEEK_END ) or die $!;
  my $insize = $in -> tell () or die $!;
  $in -> seek ( 0, SEEK_SET ) or die $!;
  $out -> seek ( $begin, SEEK_SET ) or die $!;

  if ($insize > $size) {
      printf STDERR "flashmanage fatal error: File " . $file . " too large (%d > %d)\n", $insize, $size;
      printf STDERR "adapt partition size with configure arguments --with-rootpartitionsize and --with-datapartitionsize\n";
      return 0;
  }

  my $buf;

  my $temp = $insize;
  while ( $temp > 4096 )
  {
    $in -> sysread ( $buf, 4096 );
    $out -> syswrite ( $buf, 4096 );
    $temp -= 4096;
  }

  $in -> sysread ( $buf, $temp );
  $out -> syswrite ( $buf, $temp );

  if ( $insize < $size )
  {
    part_write_pad ( $out, $begin + $insize, $size - $insize );
  }
  return 1;
}

sub part_write_pad
{
  my $out = shift;
  my $begin = shift;
  my $size = shift;

  $out -> seek ( $begin, SEEK_SET );

  my $buf = "\xff"x$size;
  $out -> syswrite ( $buf, $size );
}

$rootsize = oct($rootsize) if $rootsize =~ /^0/;
if ( $rootsize > 0 ) 
{
    $partdef{'2'}->[2] = $rootsize;
    $partdef{'3'}->[1] = $partdef{'2'}->[1] + $rootsize;
    $partdef{'3'}->[2] = $partdef{'4'}->[1] - $partdef{'3'}->[1];
	printf STDERR "2 (%d  %d)\n", $partdef{'2'}->[1], $partdef{'2'}->[2];
	printf STDERR "3 (%d  %d)\n", $partdef{'3'}->[1], $partdef{'3'}->[2];
}
$datasize = oct($datasize) if $datasize =~ /^0/;
if ( $datasize > 0 ) 
{
    $partdef{'5'}->[2] = $datasize;
    $partdef{'5'}->[1] = 0xfc0000 - $datasize;
    $partdef{'4'}->[1] = $partdef{'5'}->[1] - $partdef{'4'}->[2];
    $partdef{'3'}->[2] = $partdef{'4'}->[1] - $partdef{'3'}->[1];
	printf STDERR "2 (%d  %d)\n", $partdef{'2'}->[1], $partdef{'2'}->[2];
	printf STDERR "3 (%d  %d)\n", $partdef{'3'}->[1], $partdef{'3'}->[2];
	printf STDERR "4 (%d  %d)\n", $partdef{'4'}->[1], $partdef{'4'}->[2];
	printf STDERR "5 (%d  %d)\n", $partdef{'5'}->[1], $partdef{'5'}->[2];
}
if ( not defined ( $operation ) )
{
  pod2usage ( -message => "No operation given.", -exitstatus => 0, -verbose => 1 );
}
elsif ( $operation eq "build" )
{
  my $out = IO::File -> new ( $image, O_CREAT | O_TRUNC | O_WRONLY ) or die $!;

  my $success = 1;
  foreach ( sort ( keys ( %partdef ) ) )
  {
    if ( defined ( $parts { $partdef { $_ } -> [0] } ) )
    {
      $success = $success && part_write ( $out, $parts { $partdef { $_ } -> [0] }, $partdef { $_ } -> [1], $partdef { $_ } -> [2], $partdef { $_ } -> [3] );
    }
    else
    {
      part_write_pad ( $out, $partdef { $_ } -> [1], $partdef { $_ } -> [2] );
    }
  }
  close($out);
  if (! $success) {
      unlink($image);
      exit(1);
  }
}
elsif ( $operation eq "replace" )
{
  my $out = IO::File -> new ( $image, O_WRONLY ) or die $!;

  my $success = 1;
  foreach ( sort ( keys ( %partdef ) ) )
  {
    if ( defined ( $parts { $partdef { $_ } -> [0] } ) )
    {
      $success = $success && part_write ( $out, $parts { $partdef { $_ } -> [0] }, $partdef { $_ } -> [1], $partdef { $_ } -> [2] );
    }
  }
  close($out);
  if (! $success) {
      unlink($image);
      exit(1);
  }
}
elsif ( $operation eq "extract" )
{
  my $in = IO::File -> new ( $image, O_RDONLY ) or die $!;

  foreach ( sort ( keys ( %partdef ) ) )
  {
    if ( defined ( $parts { $partdef { $_ } -> [0] } ) )
    {
      part_read ( $in, $parts { $partdef { $_ } -> [0] }, $partdef { $_ } -> [1], $partdef { $_ } -> [2] );
    }
  }
}
elsif ( $operation eq "print" )
{
  my ( $name, $begin, $end, $size );

  format STDOUT_TOP =
name       : begin    - end      (size)
.
  format STDOUT =
@<<<<<<<<<<: 0x^>>>>> - 0x^>>>>> (0x^>>>>>)
$name,         $begin,    $end,     $size
.

  foreach ( sort ( keys ( %partdef ) ) )
  {
    $name = $partdef { $_ } -> [0];
    $begin = sprintf ( "%06x", $partdef { $_ } -> [1] );
    $end = sprintf ( "%06x", $partdef { $_ } -> [1] + $partdef { $_ } -> [2] );
    $size = sprintf ( "%06x", $partdef { $_ } -> [2] );
    write;
  }
}
else
{
  pod2usage ( -message => "Unknown operation.", -exitstatus => 0, -verbose => 1 );
}

__END__

=head1 NAME

flashmanage

=head1 SYNOPSIS

flashmanage [OPTIONS]

  -i, --image FILE      image file
  -o, --operation ARG   what to do (build, extract, replace, print)
  -r, --rootsize=SIZE   size of the root partition (defaults to 0x240000)
  -d, --datasize=SIZE   size of the root partition (defaults to 0x400000)
      --part NAME=FILE  partition files
      --help            brief help message
      --man             full documentation

=head2 EXAMPLES

  flashmanage.pl -i flashimage.img -o replace --part root=root.img
  flashmanage.pl -i flashimage.img -o build --part root=root.img --part var=var.img

=cut
