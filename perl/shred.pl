#!/usr/bin/perl

# Note: While you could easily run the "find /path/to/directory --exec shred -uzv {}" 
# (or whatever) command, it wouldn't delete the directories automatically or prompt 
# you for the directory that will have its contents shredded. I also always forget
# the argument order for the "find" command anyway...

use strict;
use warnings;
use feature qw(say);
use Cwd;
use FindBin;

use lib $FindBin::RealBin;
use Utilities;

my $directory = shift @ARGV || getcwd;
shred($directory) if Utilities::prompt("Do you want to shred everything in the directory [$directory]?");

say "Finished!";

sub shred
{
    my ($current_dir) = (@_);
    chdir $current_dir;

    opendir(my $DH, $current_dir) or die "Can't open dir $current_dir: $!\n";
    foreach my $file (Utilities::get_directory_contents($DH))
    {
        if (-d $file)
        {
            shred($file);
            chdir $current_dir;
            say "Removing directory $file";
            rmdir $file or warn "WARNING: Direcotry [$file] is not empty: $!\n";
        }

        if (-f $file)
        {
            say "Shredding file: $file";
            system(qq{/usr/bin/shred -uzv "$file"});
        }
    }
    closedir $DH;
}

