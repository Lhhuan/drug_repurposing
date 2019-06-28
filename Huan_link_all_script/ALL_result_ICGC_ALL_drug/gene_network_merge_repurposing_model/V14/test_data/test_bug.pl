#把./output/01_drug_cancer_indication.txt 和"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/test_data/output/07_final_positive_and_negative.txt"
#中的负样本merge到一起，得./output/02_positive_negative_sample.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

# my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V14/validation/27354694_TCGA/output/09_calculate_features_for_logistic_regression.txt";
# my $f2 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V13/validation/27354694_TCGA/output/09_calculate_features_for_logistic_regression.txt";
my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V14/validation/27354694_TCGA/output/10_prediction_logistic_regression.txt";
my $f2 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V13/validation/27354694_TCGA/output/10_prediction_logistic_regression.txt";
# my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V13/test_data/output/09_filter_test_data_for_logistic_regression.txt";
# my $f2 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V14/test_data/output/09_filter_test_data_for_logistic_regression.txt";
my $fo1 ="./output/02_positive_negative_sample.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

# my $header = "oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tsample_type\tdrug_repurposing";
# print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^cancer_oncotree_id_type/){
       $hash1{$_}=1;
    }
}

# while(<$I2>)
# {
#     chomp;
#     my @f= split /\t/;
#     unless(/^cancer_oncotree_id_type/){
#       my $k =join("\t",@f[0..4],@f[7..24]);
#       unless (exists $hash1{$k}){
#           print "$k\n"
#       }
#     }
# }


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^cancer_oncotree_id_type/){
        unless (exists $hash1{$_}){
            print "$_\n";
        }
    }
}