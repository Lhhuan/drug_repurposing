#为./output/05_count_drug_number_in_sample_info.txt $number》20的信息 从./output/01_sorted_filter_snv_in_huan.txt提取出用于预测的信息，得
#./output/06_merge_info_used_to_prediction_and_05_count_drug_number_sample.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/05_count_drug_number_in_sample_info.txt";
my $f2 = "./output/01_sorted_filter_snv_in_huan.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/06_merge_info_used_to_prediction_and_05_count_drug_number_sample.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

my $output = "Drug_chembl_id_Drug_claim_primary_name\toncotree_id\toncotree_id_type\tdrug_entrze\tdrug_ENSG\tdrug_target_score\tend_entrze\tthe_shortest_path\tpath_length";
$output = "$output\tnormal_score_P\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED\tcancer_ENSG\tthe_final_logic\tMap_to_gene_level";
$output ="$output\tmap_to_gene_level_score\tdata_source\tMutation_ID\tpaper_sample_name";
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
    my $output = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_id\t$oncotree_id_type\t$drug_entrze\t$drug_ENSG\t$drug_target_score\t$end_entrze\t$the_shortest_path\t$path_length";
    $output = "$output\t$normal_score_P\t$cancer_specific_affected_donors\t$original_cancer_ID\t$CADD_MEANPHRED\t$cancer_ENSG\t$the_final_logic\t$Map_to_gene_level";
    $output ="$output\t$map_to_gene_level_score\t$data_source\t$Mutation_ID\t$paper_sample_name";
    my $k= "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_id\t$oncotree_id_type\t$paper_sample_name";
    unless (/^oncotree_ID/){
        if (exists $hash1{$k}){
            my @vs =@{$hash1{$k}};
            my %hash2;
            @vs = grep { ++$hash2{$_} < 2 } @vs;
            foreach my $v(@vs){
                my $output2 = "$output\t$v";
                print $O1 "$output2\n";
            }
        }
    }
}

