#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use v5.10;

package CmdOn;

use File::Basename;
use Getopt::Long;

my $IDX_FILENAME = $ENV->{CMD_ON_IDX_FILENAME} // ".cmd_on_idx";

sub set_options {
  # Try to load from the environment, falling back to defaults 
  my $pat = $ENV->{CMD_ON_PATTERN} // "XXX";

  # TODO(pscollins): usage message
  # Now check the command line
  GetOptions("pattern" => \$pat);

  # Now all that's left is where we want to do our work
  # TODO(pscollins): validate we didn't get any extra stuff
  return (dirname($ARGV[0]), $pat);
}

sub find_idx_file {
  my ($workfile, $idx_filename) = @_;
  my $workdir = dirname($workfile);

  die("Not a directory: $workdir") unless -d $workdir;
  
  return "$workdir/$idx_filename";
}

sub get_cur_idx {
  my $idx_file = shift;

  # Default to 0 if there's no file, or it's not plain text
  my $cur_idx = 0;

  if (-T $idx_file) {
    open(my $fh, '<', $idx_file) or die "Can't open $idx_file";
    # We found a plain-text idx file, let's use the number we found there
    $cur_idx = <$fh> + 1;
  }

  # Write back what we found and clobber any junk
  open(my $fh, '>', $idx_file) or die "Can't open $idx_file";
  say $fh "$cur_idx";
  close $fh;

  return $cur_idx;
}

sub get_new_filepath {
  my ($workfile, $pat, $cur_num) = @_;

  if ($workfile =~ s/$pat/$cur_num/gi) {
    # We made a replacement, all is good
    return $workfile;
  } else {
    # Stick the id on the end
    return "$workfile-$cur_num";
  }
}

sub main {
  my ($workfile, $pat) = @_;
  my $idx_file = find_idx_file($workfile, $IDX_FILENAME);

  my $cur_idx = get_cur_idx($idx_file);

  print get_new_filepath($workfile, $pat, $cur_idx);
}

unless (caller) {
  main();
}
