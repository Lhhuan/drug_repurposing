#把../../Gene-based_data/side_effect_repo_data/09_prepare_data_for_logistic_regression.txt 
#和"/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/test_data/output/01_drug_taregt_cancer_gene_differ.txt" ,
#./output/002_merge_new_negetive_sample_cancer_oncotree.txt 中提取出来，merge到一起，得./output/01_filter_original_gene_network_based_test_data.txt
#将./output/01_filter_original_gene_network_based_test_data.txt中同一drug cancer pair对应两种drug_cancer_type_id 的去掉，得./output/01_final_filter_original_gene_network_based_test_data.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../../Gene-based_data/side_effect_repo_data/09_prepare_data_for_repo_logistic_regression.txt";
my $f2 ="/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/test_data/output/004_merge_two_source_drug_cancer_info.txt";
my $f3 ="./output/002_merge_new_negetive_sample_cancer_oncotree.txt";
my $fo1 ="./output/01_filter_original_gene_network_based_test_data.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Drug\toncotree_main_ID\tdrug_cancer_type\tdrug_cancer_type_id\n";
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
my %hash2;
while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug_claim_primary_name = $f[0];
        my $oncotree_main_ID = $f[2];
        my $drug_cancer_type = "early_clinical_phase1";
        my $drug_cancer_type_id =0;
        my $output = "$Drug_claim_primary_name\t$oncotree_main_ID\t$drug_cancer_type\t$drug_cancer_type_id";
        unless(exists $hash2{$output}){
            $hash2{$output}=1;
            print $O1 "$output\n";
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

my $f4 ="./output/01_filter_original_gene_network_based_test_data.txt";
my $fo2 ="./output/01_final_filter_original_gene_network_based_test_data.txt";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O2 "Drug\toncotree_main_ID\tdrug_cancer_type_id\n";

my %hash3;
while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug/){
        my $Drug = $f[0];
        my $oncotree_main_ID = $f[1];
        my $drug_cancer_type = $f[2];
        my $drug_cancer_type_id =$f[3];
        my $k = "$Drug\t$oncotree_main_ID";
        push @{$hash3{$k}},$drug_cancer_type_id;
    }
}

foreach my $drug_cancer(sort keys %hash3){
    my @IDs_array = @{$hash3{$drug_cancer}};
    my %hash4;
    @IDs_array = grep { ++$hash4{$_} < 2 } @IDs_array;
    my $length = @IDs_array;
    unless($length >1){
        my $output = "$drug_cancer\t$IDs_array[0]";
        print $O2 "$output\n";
    }
}
