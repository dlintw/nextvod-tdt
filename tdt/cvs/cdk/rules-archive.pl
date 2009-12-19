#!/usr/bin/perl
use strict;

my $head = "download:";
my $output;
my $outputupdate;

open ( RULES, $ARGV[0] ) or die;

while ( <RULES> )
{
  chomp;
  if ( ! m/^#/ and ! m/^\s*$/ )
  {
    @_ = split ( /;/, $_ );
    my $file = $_[0];
    my $filerep = $_[0];
    $head .= " Archive/" . $file;
    $output .= "Archive/" . $file . ":\n\tfalse";
    shift @_;
    foreach ( @_ )
    {
      if ( $_ =~ m#^ftp://# )
      {
        $output .= " || \\\n\twget -c --passive-ftp -P Archive " . $_ . "/" . $file;
      }
      elsif ( $_ =~ m#^http://# )
      {
        $output .= " || \\\n\twget -c -P Archive " . $_ . "/" . $file;
      }
      elsif ( $_ =~ m#^CMD_CVS # )
      {
        $output .= " || \\\n\tcd Archive && " . $_;
        my $cvsstring = $_;
        $cvsstring =~ s/ co / up /;
        $outputupdate .= "Archive/" . $file . "up:\n\tfalse";
        $outputupdate .= " || \\\n\tcd Archive && " . $cvsstring;
      }
    }
    if ( $file =~ m/gz$/ )
    {
      $output .= " || \\\n\twget -c -P Archive ftp://ftp.stlinux.com/pub/stlinux/2.0/ST_Linux_2.0/RPM_Distribution/sh4-target-glibc-packages/" . $file;
      $output .= "\n\t\@touch \$\@";
    }
    elsif ( $file =~ m/cvs$/ )
    {
      $output .= " || \\\n\twget -c ftp://xxx.com/pub/tufsbox/cdk/src/" . $file;
      $filerep =~ s/\.cvs//;
      $output .= "\n\t\@touch -r Archive/" . $filerep . "/CVS \$\@";
      $outputupdate .= "\n\t\@touch -r Archive/" . $filerep . "/CVS \$\(subst cvsup,cvs,\$\@\)";
      $outputupdate .= "\n\n";
    }
    else
    {
      $output .= " || \\\n\twget -c -P Archive http://tuxbox.berlios.de/pub/tuxbox/cdk/src/" . $file;
      $output .= "\n\t\@touch \$\@";
    }
    $output .= "\n\n";
  }
}

close ( RULES );

$output =~ s#CMD_CVS#\$\(CMD_CVS\)#g;
$outputupdate =~ s#CMD_CVS#\$\(CMD_CVS\)#g;

print $head . "\n\n" . $output . "\n\n" . $outputupdate . "\n";
