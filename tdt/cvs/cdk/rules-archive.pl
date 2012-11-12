#!/usr/bin/perl
use strict;

my $head = "download:";
my $output;

open ( RULES, $ARGV[0] ) or die;

while ( <RULES> )
{
  chomp;
  if ( ! m/^#/ and ! m/^\s*$/ )
  {
    @_ = split ( /;/, $_ );
    my $file = $_[0];
    my $url = $_[1];
    $head .= " \$(archivedir)/" . $file;
    $output .= "\$(archivedir)/" . $file . ":\n\tfalse || ";
    $output .= "mkdir -p \$(archivedir) && ( \\\n\t";
    if ( $url =~ m#^ftp://# )
    {
      $output .= "wget -c --passive-ftp -P \$(archivedir) " . $url . "/" . $file . " || \\\n\t";
    }
    elsif ( $url =~ m#^http://# )
    {
      $output .= "wget -t 2 -T 10 -c -P \$(archivedir) " . $url . "/" . $file . " || \\\n\t";
    }
    elsif ( $url =~ m#^https://# )
    {
      $output .= "wget -t 2 -T 10 -c -P \$(archivedir) " . $url . "/" . $file . " || \\\n\t";
    }
    elsif ( $url =~ m#^cvs://# )
    {
      $output .= "cvs checkout ";
      if ( @_ > 2 )
      {
        my $revision = $_[2];
        $output .= "-r " . $revision . " ";
      }
      $output .= $url ." \$(archivedir)/" . $file . " || \\\n\t";
    }
    elsif ( $url =~ m#^svn://# )
    {
      $output .= "svn checkout ";
      if ( @_ > 2 )
      {
        my $revision = $_[2];
        $output .= "-r " . $revision . " ";
      }
      $output .= $url ." \$(archivedir)/" . $file . " || \\\n\t";
    }
    elsif ( $url =~ m#^git://# )
    {
      $output .= "git clone ";
      if ( @_ > 3 )
      {
        my $branch = $_[3];
        $output .= "-b " . $branch . " ";
      }
      $output .= $url ." \$(archivedir)/" . $file . " ";
      if ( @_ > 2 )
      {
        my $revision = $_[2];
        $output .= "&& (cd \$(archivedir)/" . $file . "; git checkout " . $revision . "; cd -) ";
      }
      $output .= "|| \\\n\t";
    }
    $output .= "false )";
    $output .= "\n\t\@touch \$\@";
    $output .= "\n\n";
  }
}

close ( RULES );

print $head . "\n\n" . $output . "\n";
