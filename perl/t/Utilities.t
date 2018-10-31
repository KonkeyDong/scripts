#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Cwd;
use Test::Simple tests => 11;

use lib "..";
use Utilities;

test_prompt();
test_normalize_phrase();
test_get_directory_contents();
test_get_all_files_and_directories();

sub test_prompt
{
    _test_prompt_helper("y\n", 1, "prompt = 'y'");
    _test_prompt_helper("Y\n", 1, "prompt = 'Y'");
    _test_prompt_helper("n\n", 0, "prompt = 'n'");
    _test_prompt_helper("N\n", 0, "prompt = 'N'");
    _test_prompt_helper("Bologna\nY\n", 1, "prompt = 'Bologna; Y'");
}

sub mock_stdin
{
    my ($input) = (@_);
    open(my $stdin, "<", \ $input) or die "Cannot open STDIN to read from string: $!";
    return $stdin;
}

sub _test_prompt_helper
{
    my ($input, $expected_output, $test_name) = (@_);

    local *STDIN = mock_stdin($input);
    ok(Utilities::prompt() == $expected_output, $test_name);
}

sub test_normalize_phrase
{
    ok(Utilities::_normalize_phrase() eq "", "_normalize_phrase('')");
    ok(Utilities::_normalize_phrase("Hello, John   ") eq "Hello, John", "_normalize_phrase('Hello, John   ')");
    ok(Utilities::_normalize_phrase("Will this work?", "(y/n)") eq "Will this work? (y/n)", "_normalize_phrase('Will this work? (y/n)')");
    ok(Utilities::_normalize_phrase("How about this?  ", "(y/n)") eq "How about this? (y/n)", "_normalize_phrase('How about this?   (y/n)')");
}

sub test_get_directory_contents
{
    # setup
    mkdir "foo", oct(774);
    chdir "foo";
    _write_file("bar.txt");
    my $current_directory = getcwd;
    opendir(my $DH, $current_directory) or die "Open directory error: $!";

    my @files = Utilities::get_directory_contents($DH);
    
    ok(scalar @files == 1, "Directory should have exactly 1 file");
    ok("$current_directory/bar.txt" eq $files[0], "get_directory_contents() should return a full file path");

    # cleanup
    unlink "bar.txt";
    chdir "..";
    rmdir "foo";
    closedir($DH);
}

sub test_get_all_files_and_directories
{
    # setup
    mkdir "foo", oct(774);
    _write_file("foo/bar1.txt");
    _write_file("foo/bar2.txt");
    _write_file("foo/bar3.txt");
    mkdir "foo/inner_foo", oct(774);
    _write_file("foo/inner_foo_bar1.txt");
    _write_file("foo/inner_foo_bar2.txt");
    mkdir "foo/inner_foo/more_inner", oct(774);
    _write_file("foo/inner_foo/more_inner/example.txt");
    
    my ($files, $directories) = Utilities::get_all_files_and_directories("foo");
    ok(scalar @{$files} == 6, "Number of files found should be 6");
    ok(scalar @{$directories} == 2, "Number of directories found should be 2");

    ok($directories->[0] eq '/home/john/scripts/perl/t/foo/inner_foo', "Directory1 should be a full path");
    ok($directories->[1] eq '/home/john/scripts/perl/t/foo/inner_foo/more_inner', "Directory2 should be a full path");

    # cleanup
    unlink(@{$files});
    rmdir $_ foreach(reverse @{$directories});
}

sub _write_file
{
    my ($name) = (@_);

    open(my $FH, ">", $name) or die "Open file error: $!\n";
    say $FH "bologna"    ;
    close($FH);
    
    return;
}
