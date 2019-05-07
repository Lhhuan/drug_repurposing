#用Final_ID_project.txt和pathogenicity_mutation_id.txt得致病性id和project文件Final_pathogenicity_ID_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./pathogenicity_mutation_id.txt";
my $f2 = "./Final_ID_project.txt";
my $fo1 = "./Final_pathogenicity_ID_project.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "ID\tproject\tcancer_specific_affected_donors\n";

while(<$I1>)
{
    chomp;
    unless (/^ID/){
        my @f = split/\t/;
        my $ID = $f[0];
        my $CADD_PHRED_score = $f[1];
        $hash1{$ID}=$CADD_PHRED_score;
    }
}

while(<$I2>)
{
    chomp;
    unless (/^ID/){
        my @f= split/\t/;
        my $ID = $f[0];
        if (exists $hash1{$ID}){
            print $O1 "$_\n";
        }
        
    }
}
