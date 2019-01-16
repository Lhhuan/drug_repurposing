#把./output/10_prediction_logistic_regression.txt和./output/28847918_normal_type.txt merge 到一起，级drug cancer sample pair对应的突变信息merge到一起（./output/11_01_snv_in_huan_info.txt），
#得./output/11_prediction_and_icgc_result_info.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;

my $f1 = "./output/28847918_normal_type.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/11_01_snv_in_huan_info.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 = "./output/10_prediction_logistic_regression.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 = "./output/11_prediction_and_icgc_result_info.txt";
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
        my $Drug = $f[0];
        my $Sample = $f[1];
        my $Value =$f[2];
        my $k = "$Drug\t$Sample";
        $hash1{$k}=$Value;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $paper_sample_name = $f[2];
        my $oncotree_id =$f[3];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$paper_sample_name\t$oncotree_id";
        my $v = join("\t",@f[5..25]);
        push @{$hash2{$k}},$v;
    }
}


while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug_in_paper = $f[1];
        my $oncotree_id = $f[2];
        my $oncotree_id_type = $f[3];
        my $paper_sample_name = $f[4];
        my $average_effective_drug_target_score = $f[5];
        my $average_mutation_frequency = $f[6];
        my $average_mutation_pathogenicity = $f[7];
        my $average_mutation_map_to_gene_level_score = $f[8];
        my $average_the_shortest_path_length = $f[9];
        my $min_rwr_normal_P_value = $f[10];
        my $median_rwr_normal_P_value = $f[11];
        my $cancer_gene_exact_match_drug_target_ratio = $f[12];
        my $average_del_svscore = $f[13];
        my $average_dup_svscore = $f[14];
        my $average_inv_svscore = $f[15];
        my $average_tra_svscore = $f[16];
        my $average_cnv_svscore = $f[17];
        my $predict_value =$f[18];
        my $k1 = "$drug_in_paper\t$paper_sample_name";
        my $k2 = "$Drug_chembl_id_Drug_claim_primary_name\t$paper_sample_name\t$oncotree_id";
        my $output1 = join("\t",@f[0..4]);
        my $output2 = join ("\t",@f[5..17]);
        # print STDERR "$k\n";
        if (exists $hash1{$k1}){
            # print STDERR "$k\n";
            my $value_in_paper = $hash1{$k1};
            if (exists $hash2{$k2}){
                my @mutation_infos = @{$hash2{$k2}};
                foreach  my $info(@mutation_infos){
                    my $output= "$output1\t$predict_value\t$value_in_paper\t$output2\t$info";
                    unless(exists $hash3{$output}){
                        $hash3{$output} =1;
                        print $O1 "$output\n";
                    }
                }
            }
            else{
                print STDERR "$k2\n";
            }
        }
        else{
            print STDERR "$k1\n";
        }
    }
}


close ($O1);