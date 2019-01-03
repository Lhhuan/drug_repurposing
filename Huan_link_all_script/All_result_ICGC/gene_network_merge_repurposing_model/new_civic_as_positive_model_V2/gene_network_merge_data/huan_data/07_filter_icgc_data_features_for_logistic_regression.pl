#用./output/04_final_data_for_calculate_features.txt中的sub oncotree id(没有sub的采用main，也就是相当于用sub那列)和 drug pair 提出 ./output/06_merge_sub_main_features_for_logistic_regression.txt中
#的feature，得./output/07_filter_icgc_data_features_for_logistic_regression.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;




# my $f1 = "./1234.txt";
my $f1 = "./output/04_final_data_for_calculate_features.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/06_merge_sub_main_features_for_logistic_regression.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/07_filter_icgc_data_features_for_logistic_regression.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header="cancer_oncotree_id_type\tDrug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_id\taverage_effective_drug_target_score\taverge_mutation_frequency";
$header ="$header\taverge_mutation_pathogenicity\taverge_mutation_map_to_gene_level_score\taverage_the_shortest_path_length\tmin_rwr_normal_P_value\tmedian_rwr_normal_P_value";
$header = "$header\tcancer_gene_exact_match_drug_target_ratio\taverage_del_svscore\taverage_dup_svscore\taverage_inv_svscore\taverage_tra_svscore\taverage_cnv_svscore";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $oncotree_ID_detail = $f[13];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID_detail";
        $hash1{$k} =1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^cancer_oncotree_id_type/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $oncotree_ID_detail = $f[2];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID_detail";
        if (exists $hash1{$k}){
            print $O1 "$_\n";
        }
    }
}