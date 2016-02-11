#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use v5.10;

use File::Basename;

use Data::Dumper;

my $IDX_FILENAME = ".cmd_on_idx";
my $PAT = "XXX";

sub main {
  my $workdir = dirname($ARGV[0]);
  my $idx_file = "$workdir/${IDX_FILENAME}";
  my $cur_num = 0;
  die("Not a directory: $workdir") unless -e $workdir && -d $workdir;

  if (-f $idx_file && -s $idx_file) {
    open(my $fh, '<', $idx_file);
    $cur_num = <$fh> + 1;
    close $fh;
  }

  open(my $fh, '>', $idx_file);
  print $fh "$cur_num";

  print $ARGV[0] =~ s/$PAT/$cur_num/rg;
}

main();
