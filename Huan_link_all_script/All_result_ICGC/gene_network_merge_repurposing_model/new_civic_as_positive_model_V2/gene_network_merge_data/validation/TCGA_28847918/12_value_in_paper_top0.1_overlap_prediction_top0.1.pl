#看./output/11_prediction_and_icgc_result_top0.1.txt和./output/11_prediction_and_icgc_result_sorted_by_value_in_paper_top_0.1.txt的overlap
#得./output/12_value_in_paper_top0.1_overlap_prediction_top0.1.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;

my $f1 = "./output/11_prediction_and_icgc_result_top0.1.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/11_prediction_and_icgc_result_sorted_by_value_in_paper_top_0.1.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/12_value_in_paper_top0.1_overlap_prediction_top0.1.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $output = "Drug_chembl_id_Drug_claim_primary_name\tdrug_in_paper\toncotree_id\toncotree_id_type\tpaper_sample_name\tpredict_value\tValue_in_paper";
$output = "$output\taverage_effective_drug_target_score\taverage_mutation_frequency\taverage_mutation_pathogenicity\taverage_mutation_map_to_gene_level_score";
$output = "$output\taverage_the_shortest_path_length\tmin_rwr_normal_P_value\tmedian_rwr_normal_P_value\tcancer_gene_exact_match_drug_target_ratio\taverage_del_svscore";
$output = "$output\taverage_dup_svscore\taverage_inv_svscore\taverage_tra_svscore\taverage_cnv_svscore";
$output = "$output\tMutation_ID\tchr\tpos\tref\talt\tchr:g.posref>alt\tdrug_entrze\tdrug_ENSG\tdrug_target_score";
$output = "$output\tend_entrze\tthe_shortest_path\tpath_length\tnormal_score_P\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED\tcancer_ENSG\tthe_final_logic\tMap_to_gene_level\tmap_to_gene_level_score";
$output= "$output\tdata_source";

print $O1 "$output\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug/){
        my @f =split/\t/;
        my $k=$_;
        $hash1{$k}=1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug/){
        my @f =split/\t/;
        my $k=$_;
        if (exists $hash1{$k}){
            print $O1 "$k\n";
        }
    }
}
