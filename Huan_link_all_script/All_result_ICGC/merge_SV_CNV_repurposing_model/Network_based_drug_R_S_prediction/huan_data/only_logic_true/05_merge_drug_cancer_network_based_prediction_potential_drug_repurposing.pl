#因为./output/04_logistic_regression_prediction_potential_drug_repurposing_data.txt中没有drug cancer 的信息，
#所以用./output/03_calculate_for_network_based_repo_logistic_regression_data.txt和./output/04_logistic_regression_prediction_potential_drug_repurposing_data.txt merge起来，
#并得到预测结果为repurposing 的文件./output/05_merge_drug_cancer_network_based_prediction_potential_drug_repurposing.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/03_calculate_for_network_based_repo_logistic_regression_data.txt";
my $f2 = "./output/04_logistic_regression_prediction_potential_drug_repurposing_data.txt";
my $fo1 = "./output/05_drug_cancer_prediction_repurposing.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug/){
        my $Drug = $f[0];
        my $cancer_oncotree_main_id =$f[1];
        my $v = "$Drug\t$cancer_oncotree_main_id";
        my $average_drug_score =$f[2];
        my $averge_gene_mutation_frequency = $f[3];
        my $average_gene_CADD_score = $f[4];
        my $average_mutation_map_to_gene_level_score = $f[5];
        my $average_path_length = $f[6];
        my $min_rwr_normal_P_value = $f[7];
        my $averge_gene_num_in_del_hotspot = $f[9];
        my $averge_gene_num_in_dup_hotspot = $f[10];
        my $averge_gene_num_in_inv_hotspot = $f[11];
        my $averge_gene_num_in_tra_hotspot = $f[12];
        my $averge_gene_num_in_cnv_hotspot = $f[13];
        #my $k = "$average_drug_score\t$averge_gene_mutation_frequency\t$average_gene_CADD_score\t$average_mutation_map_to_gene_level_score\t$average_path_length\t$min_rwr_normal_P_value";
        my $k =join("\t",@f[2..7],@f[9..13]);
        push @{$hash1{$k}},$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    if(/^average_drug_score/){
        print $O1 "Drug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\t$_\n";
    }
        else{
        my $average_drug_score = $f[0];
        my $averge_gene_mutation_frequency =$f[1];
        my $average_gene_CADD_score = $f[2];
        my $average_mutation_map_to_gene_level_score = $f[3];
        my $average_path_length = $f[4];
        my $min_rwr_normal_P_value = $f[5];
        my $k = join("\t",@f[0..10]);
        my $predict = $f[11];
        my $prediction_value = $f[12];
        #my $k = "$average_drug_score\t$averge_gene_mutation_frequency\t$average_gene_CADD_score\t$average_mutation_map_to_gene_level_score\t$average_path_length\t$min_rwr_normal_P_value";
        my $v = "$predict\t$prediction_value";
        push @{$hash2{$k}},$v;
    }
}

foreach my $features(sort keys %hash1){
    # print STDERR "$features\n";
    my @drug_cancers = @{$hash1{$features}};
    if(exists $hash2{$features}){
        
        my @scores = @{$hash2{$features}};
        foreach my $drug_cancer(@drug_cancers){
            foreach my $score(@scores){
                my $output1 = "$drug_cancer\t$features\t$score";
                unless(exists $hash3{$output1}){
                    $hash3{$output1} =1;
                    print $O1 "$output1\n";
                }
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄


my $f3 = "./output/05_drug_cancer_prediction_repurposing.txt";
my $fo2 = "./output/05_merge_drug_cancer_network_based_prediction_potential_drug_repurposing.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    if(/^Drug/){
        print $O2 "$_\n";
    }
    else{
        my $score = $f[-2];
        if ($score>0){#也就是等于1
            print $O2 "$_\n";
        }
    }
}