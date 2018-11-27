
#!/usr/bin/perl

use warnings;
use strict;
my $file1 = "./data/CGD.txt";
my $file2 = "./data/interactions.tsv";
open my $file_hander1, '<', $file1 or die "$0 : failed to open input file '$file1' : $!\n";
open my $file_hander2, '<', $file2 or die "$0 : failed to open input file '$file2' : $!\n";
my @gene1;
my @disease;

my $ith_row = 0;
my %file1=("@gene1" => $ith_row );
while(<$file_hander1>)
{
    
#	$ith_row++;

	
    chomp;
    @gene1= (split /\t/,$_)[0];
     @disease= (split /\t/,$_)[3];
     $ith_row++;
    
     print "@gene1\n";
    #print "@disease\n";
    # my %relation1=('@gene1','@disease');
}