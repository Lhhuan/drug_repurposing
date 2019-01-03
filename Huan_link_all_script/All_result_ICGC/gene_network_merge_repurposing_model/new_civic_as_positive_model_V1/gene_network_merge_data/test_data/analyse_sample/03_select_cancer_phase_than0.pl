#将./output/02_statistics_drug_fda_approval_and_indication_cancer_final.txt中indication是cancer，并且max phase>0的筛选出来，得./output/03_select_cancer_phase_than0.txt,
#并对../output/09_filter_test_data_for_logistic_regression.txt 进行筛选，得../output/04_filter_features_cancer_phase_than0.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;


my $f1 ="./output/02_statistics_drug_fda_approval_and_indication_cancer.txt";
my $fo1 ="./output/03_select_cancer_phase_than0.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash5,%hash6);
my $header = "Drug_chembl_id_Drug_claim_primary_name\trepo_cancer_id\trepurposing\tindication_is_cancer\tMax_phase";
print $O1 "$header\n";
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $repo_cancer_id = $f[1];
        my $repo_type = $f[2];
        my $indication_is_cancer = $f[3];
        my $Max_phase = $f[4];
        if ($indication_is_cancer =~/Y/){
            unless($Max_phase=~/unknown/){
                if ($Max_phase >0){
                    my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$repo_cancer_id\t$repo_type";
                    $hash1{$k}=1;
                    print $O1 "$_\n";
                }
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

my $f2 ="../output/09_filter_test_data_for_logistic_regression.txt";
my $fo2 ="../output/04_filter_features_cancer_phase_than0.txt";

open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^cancer_oncotree_id_type/){
        print $O2 "$_\n";
    }
    else{
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $repo_cancer_id = $f[2];
        my $repo_type = $f[-1];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$repo_cancer_id\t$repo_type";
        if(exists $hash1{$k}){
            print $O2 "$_\n";
        }
        
    }
}