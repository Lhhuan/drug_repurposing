#将没有出现在./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl.txt和../../test_data/output/09_filter_test_data_for_logistic_regression.txt 中的
#../../huan_data/output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt 的drug cancer pair信息抽出来，得./output/05_filter_out_mtctscan_out_test_in_huan.txt
#得在./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl.txt中出现的drug cancer pair,但不在../../test_data/output/09_filter_test_data_for_logistic_regression.txt的
#文件./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my $f1 ="./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl.txt";
my $f2 ="../../test_data/output/09_filter_test_data_for_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 ="../../huan_data/output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 ="./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./output/05_filter_out_mtctscan_out_test_in_huan.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1, %hash2 ,%hash3, %hash4);


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^cancer_oncotree_id_type/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_id = $f[2];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        $hash1{$k} =1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^cancer_oncotree_id_type/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_id = $f[2];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        $hash2{$k} =1;
    }
}


while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    if (/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$_\n";
        # print $O2 "$_\n";
    }
    else{
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $cancer_oncotree_id = $f[1];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        # print STDERR "$k\n";
        unless(exists $hash2{$k}){ #没有在训练集这中drug cancer pair
            if (exists $hash1{$k}){ #在positive中存在的
                print $O1 "$_\n";
            }
            else{
                print $O2 "$_\n";
            }
        }
    }
}
