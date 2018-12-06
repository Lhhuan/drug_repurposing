##把011_drug_side_effect_cancer.txt和03_unique_drug_repo_oncotree.txt, 01_filter_side_effect_from_drugbank_oncotree.txt 以及drug clinical withdrawm的药物信息Withdrawn_cancer_drug_huan.txt merge成一个文件，得文件04_merge_repo_side-effect_withdrawn_data.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./011_drug_side_effect_cancer.txt";
my $f2 ="./03_unique_drug_repo_oncotree.txt";
my $f3 ="./01_filter_side_effect_from_drugbank_oncotree.txt";
my $f4 ="./Withdrawn_cancer_drug_huan.txt";
#my $f5 ="./033_random_select_drug_no_function_cancer.txt";
my $f5 ="./huan_drug_indication_cancer.txt";
my $f6 ="./0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn_oncotree.txt";


my $fo1 ="./04_merge_repo_side-effect_withdrawn_data.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $I6, '<', $f6 or die "$0 : failed to open input file '$f6' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "drug\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\tside-effect_or_repo\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug/){
        my $Drug= $f[0];
        my $side_effect = $f[1];
        my $oncotree_detail_term = $f[3];
        my $oncotree_detail_ID = $f[4];
        my $oncotree_main_term = $f[5];
        my $oncotree_main_ID = $f[6];
        unless($oncotree_main_term =~/NA/){
            my $k = "$Drug\t$oncotree_detail_term\t$oncotree_detail_ID\t$oncotree_main_term\t$oncotree_main_ID\tSide_effect";
            unless(exists $hash1{$k}){
                $hash1{$k}=1;
                print $O1 "$k\n";
            }
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drug= $f[0];
        my $oncotree_detail_term = $f[1];
        my $oncotree_detail_ID = $f[2];
        my $oncotree_main_term = $f[3];
        my $oncotree_main_ID = $f[4];
        my $k = "$drug\t$oncotree_detail_term\t$oncotree_detail_ID\t$oncotree_main_term\t$oncotree_main_ID\tDrug_repo";
        unless(exists $hash2{$k}){
            $hash2{$k}=1;
            print $O1 "$k\n";
        }
    }
}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^name/){
        my $drug= $f[0];
        my $oncotree_detail_term = "NA";
        my $oncotree_detail_ID ="NA";
        my $oncotree_main_term = $f[4];
        my $oncotree_main_ID = $f[5];
        unless($oncotree_main_term =~/NA/){
            my $k = "$drug\t$oncotree_detail_term\t$oncotree_detail_ID\t$oncotree_main_term\t$oncotree_main_ID\tSide_effect";
            unless(exists $hash2{$k}){
                $hash1{$k}=1;
                print $O1 "$k\n";
            }
        }
    }
}

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug/){
        my $drug= $f[0];
        my $oncotree_detail_term = $f[3];
        my $oncotree_detail_ID = $f[4];
        my $oncotree_main_term = $f[5];
        my $oncotree_main_ID = $f[6];
        my $k = "$drug\t$oncotree_detail_term\t$oncotree_detail_ID\t$oncotree_main_term\t$oncotree_main_ID\tWithdrawn";
        unless(exists $hash2{$k}){
            $hash2{$k}=1;
            print $O1 "$k\n";
        }
    }
}


while(<$I5>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $drug= $f[0];
        my $oncotree_detail_term = "NA";
        my $oncotree_detail_ID = "NA";
        my $oncotree_main_term = "NA";
        my $oncotree_main_ID = $f[1];
        my $k = "$drug\t$oncotree_detail_term\t$oncotree_detail_ID\t$oncotree_main_term\t$oncotree_main_ID\tIndication";
        unless(exists $hash2{$k}){
            $hash2{$k}=1;
            print $O1 "$k\n";
        }
    }
}


while(<$I6>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug_name/){
        my $drug= $f[0];
        my $status = $f[1];
        my $oncotree_detail_term = "NA";
        my $oncotree_detail_ID = "NA";
        my $oncotree_main_term = "NA";
        my $oncotree_main_ID = $f[3];
        my $k = "$drug\t$oncotree_detail_term\t$oncotree_detail_ID\t$oncotree_main_term\t$oncotree_main_ID\t$status";
        unless(exists $hash2{$k}){
            $hash2{$k}=1;
            print $O1 "$k\n";
        }
    }
}

print $O1 "drug_name\tstatus\tdisease\toncotree_main_ID\n";