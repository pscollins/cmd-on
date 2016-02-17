#! /usr/bin/perl -T
use strict;
use warnings;
use v5.10;

use Test::More tests => 7;
use File::Temp qw(tempdir);

require "bin/cmd-on.pl";

# Make a temporary directory for testing
my $testdir = tempdir(CLEANUP => 0);
my $idx_file = CmdOn::find_idx_file("$testdir/foo-XXX", ".foobar");

diag "Running tests in: $testdir";

is($idx_file, "$testdir/.foobar");
is(CmdOn::get_cur_idx($idx_file), 0);
is(CmdOn::get_cur_idx($idx_file), 1);

is(CmdOn::get_new_filepath("$testdir/foo-XXX", "XXX", 3), "$testdir/foo-3");
is(CmdOn::get_new_filepath("$testdir/foo-xxx", "XXX", 3), "$testdir/foo-3");
is(CmdOn::get_new_filepath("$testdir/foo-YYY", "YYY", 3), "$testdir/foo-3");
is(CmdOn::get_new_filepath("$testdir/foo", "YYY", 3), "$testdir/foo-3");
