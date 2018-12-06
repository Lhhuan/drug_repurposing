#将./output/021_drug_cancer_pair_average_gene_in_inv_tra.txt和./output/03_calculate_for_network_based_repo_logistic_regression_data_cnv_dup_del.txt merge 在一起，
#得./output/031_calculate_for_network_based_repo_logistic_regression_data_final.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;


my $f1 = "./output/021_drug_cancer_pair_average_gene_in_inv_tra.txt";
my $f2 = "./output/03_calculate_for_network_based_repo_logistic_regression_data_cnv_dup_del.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/031_calculate_for_network_based_repo_logistic_regression_data_final.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header="Drug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\taverage_drug_score\taverge_gene_mutation_frequency\taverage_gene_CADD_score\taverage_mutation_map_to_gene_level_score\taverage_path_length\tmin_rwr_normal_P_value\tlogic_true_ratio";
$header = "$header\taverge_gene_num_in_del_hotspot\taverge_gene_num_in_dup_hotspot\taverge_gene_num_in_cnv_hotspot\taverge_gene_num_in_inv_hotspot\taverge_gene_num_in_tra_hotspot";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/Drug_chembl_id_Drug_claim_primary_name/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $cancer_oncotree_main_id = $f[1];
        my $averge_gene_num_in_inv_hotspot = $f[2];
        my $averge_gene_num_in_tra_hotspot = $f[3];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_main_id";
        my $v= "$averge_gene_num_in_inv_hotspot\t$averge_gene_num_in_tra_hotspot";
        $hash1{$k}=$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/Drug_chembl_id_Drug_claim_primary_name/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $cancer_oncotree_main_id = $f[1];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_main_id";
        if (exists $hash1{$k}){
            my $v = $hash1{$k};
            my $out = "$_\t$v";
            unless(exists $hash2{$out}){
                $hash2{$out}=1;
                print $O1 "$out\n";
            }
        } 
        else{ #真正的数据在这里是不会输出的，也所有的$k都存在$hash1
            print STDERR "$k\n";
            my $out = "$_\t0\t0";
            unless(exists $hash2{$out}){
                $hash2{$out}=1;
                print $O1 "$out\n";
            }
        }
    
    }
}

