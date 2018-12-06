#把../../Gene-based_data/side_effect_repo_data/09_prepare_data_for_repo_logistic_regression.txt 
#和"/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/test_data/output/01_drug_taregt_cancer_gene_differ.txt" 中提取出来，merge到一起，
#得./output/01_filter_original_gene_network_based_test_data.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../../Gene-based_data/side_effect_repo_data/09_prepare_data_for_repo_logistic_regression.txt";
my $f2 ="/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/test_data/output/004_merge_two_source_drug_cancer_info.txt";
my $fo1 ="./output/01_filter_original_gene_network_based_test_data.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Drug_claim_primary_name\toncotree_main_ID\tdrug_cancer_type\tdrug_cancer_type_id\n";
my %hash1;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug_claim_primary_name = $f[0];
        my $oncotree_main_ID = $f[1];
        my $drug_cancer_type = $f[-1];
        unless($drug_cancer_type=~/Side_effect/){
            if($drug_cancer_type=~/Drug_repo|Indication/){
                my $drug_cancer_type_id =1;
                my $output ="$Drug_claim_primary_name\t$oncotree_main_ID\t$drug_cancer_type\t$drug_cancer_type_id";
                unless(exists $hash1{$output}){
                    $hash1{$output} =1;
                    print $O1 "$output\n";
                }
            }
            elsif($drug_cancer_type=~/Terminated|Withdrawn/){
                my $drug_cancer_type_id =0;
                my $output ="$Drug_claim_primary_name\t$oncotree_main_ID\t$drug_cancer_type\t$drug_cancer_type_id";
                unless(exists $hash1{$output}){
                    $hash1{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug_claim_primary_name = $f[0];
        my $oncotree_main_ID = $f[10];
        my $drug_cancer_type = $f[11];
        unless($drug_cancer_type=~/Side_effect/){
            if($drug_cancer_type=~/Drug_repo|Indication/){
                my $drug_cancer_type_id =1;
                my $output ="$Drug_claim_primary_name\t$oncotree_main_ID\t$drug_cancer_type\t$drug_cancer_type_id";
                unless(exists $hash1{$output}){
                    $hash1{$output} =1;
                    print $O1 "$output\n";
                }
            }
            elsif($drug_cancer_type=~/Terminated|Withdrawn/){
                my $drug_cancer_type_id =0;
                my $output ="$Drug_claim_primary_name\t$oncotree_main_ID\t$drug_cancer_type\t$drug_cancer_type_id";
                unless(exists $hash1{$output}){
                    $hash1{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}

