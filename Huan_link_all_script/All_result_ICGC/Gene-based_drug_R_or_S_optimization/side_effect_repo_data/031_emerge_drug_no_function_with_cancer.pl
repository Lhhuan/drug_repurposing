#把"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt" 中的drug，除去出现在"/f/mulinlab/huan/All_result_ICGC/16.1_drug_cancer_in_icgc_project.txt"中的药物，
 #除去011_drug_side_effect_cancer.txt和01_filter_side_effect_from_drugbank_oncotree.txt中的药物，得031_emerge_drug_no_function_with_cancer.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt";
my $f2 ="/f/mulinlab/huan/All_result_ICGC/16.1_drug_cancer_in_icgc_project.txt";
my $f3 ="./01_filter_side_effect_from_drugbank_oncotree.txt";
my $f4 ="./011_drug_side_effect_cancer.txt";
my $fo1 ="./031_emerge_drug_no_function_with_cancer.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Drug= $f[0];
        $Drug =uc($Drug);
        $Drug =~s/"//g;
        $hash1{$Drug}=1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Drug= $f[0];
        $Drug =uc($Drug);
        $Drug =~s/"//g;
        $hash2{$Drug}=1;
    }
}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^name/){
        my $Drug= $f[0];
        $Drug =uc($Drug);
        $Drug =~s/"//g;
        $hash3{$Drug}=1;
    }
}

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug/){
        my $Drug= $f[0];
        $Drug =uc($Drug);
        $Drug =~s/"//g;
        $hash4{$Drug}=1;
    }
}


foreach my $drug (sort keys %hash1){
    unless (exists $hash2{$drug}){
        unless (exists $hash3{$drug}){
            unless (exists $hash4{$drug}){
                print $O1 "$drug\n";
            }
        }
    }
}