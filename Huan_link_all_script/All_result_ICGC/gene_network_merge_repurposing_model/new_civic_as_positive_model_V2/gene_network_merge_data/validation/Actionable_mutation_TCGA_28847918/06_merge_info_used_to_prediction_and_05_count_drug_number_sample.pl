#为./output/05_count_drug_number_in_sample_info.txt $number>10的信息 从./output/01_sorted_filter_snv_in_huan.txt和output/02_calculate_features_for_logistic_regression.txt提取出用于预测的信息，得
#./output/06_merge_info_used_to_prediction_and_05_count_drug_number_sample.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/05_count_drug_number_in_sample_info.txt";
my $f2 = "./output/01_sorted_filter_snv_in_huan.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 = "./output/02_calculate_features_for_logistic_regression.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 = "./output/06_merge_info_used_to_prediction_and_05_count_drug_number_sample.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2);
my $header = "Drug_chembl_id_Drug_claim_primary_name\toncotree_id\toncotree_id_type\tpaper_sample_name";
$header="$header\taverage_effective_drug_target_score\taverage_mutation_frequency";
$header ="$header\taverage_mutation_pathogenicity\taverage_mutation_map_to_gene_level_score\taverage_the_shortest_path_length\tmin_rwr_normal_P_value\tmedian_rwr_normal_P_value";
$header = "$header\tcancer_gene_exact_match_drug_target_ratio\taverage_del_svscore\taverage_dup_svscore\taverage_inv_svscore\taverage_tra_svscore\taverage_cnv_svscore";
my $output = "$header\tdrug_entrze\tdrug_ENSG\tdrug_target_score\tend_entrze\tthe_shortest_path\tpath_length";
$output = "$output\tnormal_score_P\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED\tcancer_ENSG\tthe_final_logic\tMap_to_gene_level";
$output ="$output\tmap_to_gene_level_score\tdata_source\tMutation_ID";
print $O1 "$output\tpredict_repurposing_value\tnumber_of_sample_hit_drug\n";
    
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $number = $f[1];
        my $oncotree_id = $f[2];
        my $oncotree_id_type =$f[3];
        my $paper_sample_name = $f[4];
        my $predict_value =$f[5];
        if ($number>10){ #只统计$number>10
            my $k= "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_id\t$oncotree_id_type\t$paper_sample_name";
            my $v = "$predict_value\t$number";
            push @{$hash1{$k}},$v;
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    my $Drug_chembl_id_Drug_claim_primary_name = $f[2];
    my $oncotree_id = $f[0];
    my $Mutation_ID = $f[1];
    my $drug_entrze = $f[3];
    my $drug_ENSG = $f[4];
    my $drug_target_score = $f[5];
    my $end_entrze = $f[6];
    my $the_shortest_path = $f[7];
    my $path_length = $f[8];
    my $normal_score_P = $f[9];
    my $cancer_specific_affected_donors = $f[11];
    my $original_cancer_ID = $f[12];
    #--------------------------------------------
    my $CADD_MEANPHRED = $f[13];
    my $cancer_ENSG = $f[14];
    my $the_final_logic = $f[15];
    my $Map_to_gene_level = $f[16];
    my $map_to_gene_level_score = $f[17];
    my $data_source = $f[18];
    my $oncotree_id_type = $f[19];
    my $paper_sample_name = $f[20];
    my $output = "$drug_entrze\t$drug_ENSG\t$drug_target_score\t$end_entrze\t$the_shortest_path\t$path_length";
    $output = "$output\t$normal_score_P\t$cancer_specific_affected_donors\t$original_cancer_ID\t$CADD_MEANPHRED\t$cancer_ENSG\t$the_final_logic\t$Map_to_gene_level";
    $output ="$output\t$map_to_gene_level_score\t$data_source\t$Mutation_ID";
    my $k= "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_id\t$oncotree_id_type\t$paper_sample_name";
    unless (/^oncotree_ID/){
        push @{$hash2{$k}}, $output;
    }
}

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $oncotree_id = $f[1];
        my $oncotree_id_type =$f[2];
        my $paper_sample_name = $f[3];
        my $k= "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_id\t$oncotree_id_type\t$paper_sample_name";
        if (exists $hash1{$k}){
            my @v1s =@{$hash1{$k}};
            if(exists $hash2{$k}){
                my @v2s = @{$hash2{$k}};
                foreach my $v1(@v1s){
                    foreach my $v2(@v2s){
                        my $output = "$_\t$v2\t$v1";
                        my %hash3;
                        unless(exists $hash3{$output}){
                            $hash3{$output} =1;
                            print $O1 "$output\n";
                        }
                    }
                }
            }
        }
    }
}

