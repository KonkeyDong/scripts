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
use Parallel::ForkManager;

use lib $FindBin::RealBin;
use Utilities;

my $directory = shift @ARGV || getcwd;
exit 0 unless Utilities::prompt("Do you want to shred everything in the directory [$directory]?");

my ($FILES, $DIRECTOREIS) = Utilities::get_tree_contents($directory);
my $pm = Parallel::ForkManager->new(4); # 4 child processes max when dealing shredding on an SSD

SHRED:
foreach my $file (@{$FILES})
{
    $pm->start and next SHRED; # do the fork

    say "[PID: $$] Shredding file: [$file]";
    system(qq{/usr/bin/shred -uz "$file"});

    $pm->finish();
}

$pm->wait_all_children;

say "Removing directories...";
rmdir $_ foreach(@{$DIRECTOREIS});

exit 0; # success
