#将"/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/huan_data/only_logic_true/output/unique_02_filter_infos_for_calculate_feature.txt" 中的Drug_chembl_id_Drug_claim_primary_name和Drug_claim_primary_name提出来，
#和"/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/huan_data/only_logic_true/output/03_calculate_for_network_based_repo_logistic_regression_data.txt" 通过Drug_chembl_id_Drug_claim_primary_name将Drug_claim_primary_name和"../huan_data/output/03_calculate_for_network_based_repo_logistic_regression_data.txt"
#得"./output/02_drug_primary_calculate_for_network_based_repo_logistic_regression_data.txt"

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/huan_data/only_logic_true/output/unique_02_filter_infos_for_calculate_feature.txt";
my $f2 ="/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/huan_data/only_logic_true/output/03_calculate_for_network_based_repo_logistic_regression_data.txt";
my $fo1 ="./output/02_drug_primary_calculate_for_network_based_repo_logistic_regression_data.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0];
        my $Drug_claim_primary_name = $f[1];
        push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$Drug_claim_primary_name;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "Drug_claim_primary_name\t$_\n";
    }
    else{
        my $Drug= $f[0];
        if (exists $hash1{$Drug}){
            my @Drug_claim_primary_names = @{$hash1{$Drug}};
            my %hash5;
            @Drug_claim_primary_names = grep { ++$hash5{$_} < 2 } @Drug_claim_primary_names;
            foreach my $Drug_claim_primary_name(@Drug_claim_primary_names){
                my $output = "$Drug_claim_primary_name\t$_";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 " $output\n";
                }
                
            }
        }
        
    }
}

