# 把./output/unique_early_phase1_cancer_oncotree.txt和./output/001_extract_drug_cancer_clinical_recruiting_pahse1_early_phase1.txt merge在一起，
#得./output/002_merge_new_negetive_sample_cancer_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/unique_early_phase1_cancer_oncotree.txt";
my $f2 ="./output/001_extract_drug_cancer_clinical_recruiting_pahse1_early_phase1.txt"; 
my $fo1 ="./output/002_merge_new_negetive_sample_cancer_oncotree.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Drug\tCancer\toncotree\tStatus\n";
my %hash1;
my %hash2;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Cancer/){
       my $Cancer =$f[0];
       my $oncotree = $f[1];
       unless($oncotree =~/NA/){
           $hash1{$Cancer}=$oncotree;
       }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug/){
        my $Drug = $f[0];
        my $Cancer = $f[1];
        my $Status = $f[2];
        if (exists $hash1{$Cancer}){
            my $oncotree = $hash1{$Cancer};
            print $O1 "$Drug\t$Cancer\t$oncotree\t$Status\n";
        }
    }
}

