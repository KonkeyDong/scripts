#!/usr/bin/perl

package Utilities;

use strict;
use warnings;
use feature qw(say);
use File::Spec;

sub prompt
{
    my ($phrase) = (@_);
    say _normalize_phrase($phrase, "(y/n)");

    while(1)
    {
        my $response = <STDIN>;
        return 1 if $response =~ /^y$/i;
        return 0 if $response =~ /^n$/i;
    }
}

sub _normalize_phrase
{
    my ($phrase, $extra_phrase) = (@_);
    $phrase ||= "";
    $extra_phrase ||= "";

    return "" if $phrase eq ""; # no need to check $extra_phrase if $phrase is empty

    $phrase =~ s/\s+$//;
    $phrase = "$phrase $extra_phrase";
    $phrase =~ s/\s+$//;
    return $phrase;
}

# retrieve directory contents excluding "." and ".."
sub get_directory_contents
{
    my ($dh) = (@_);

    my (@buffer) = grep(!/^\.{1,2}$/, readdir $dh);
    return map { File::Spec->rel2abs($_) } @buffer;
}

{
    my (@FILES, @DIRECTORIES);
    sub get_all_files_and_directories
    {
        my ($directory) = (@_);

        # reset
        @FILES = ();
        @DIRECTORIES = ();
        _get_all_files_and_directories_helper($directory);

        return \@FILES, \@DIRECTORIES;
    }

    sub _get_all_files_and_directories_helper
    {
        my ($current_dir) = (@_);
        chdir $current_dir;

        opendir(my $DH, $current_dir) or die "Can't open dir $current_dir: $!\n";
        foreach my $file (get_directory_contents($DH))
        {
            if (-d $file)
            {
                push @DIRECTORIES, $file;
                _get_all_files_and_directories_helper($file);
                chdir $current_dir;
            }

            if (-f $file)
            {
                push @FILES, $file;
            }
        }
        closedir $DH;
    }
}

1;
