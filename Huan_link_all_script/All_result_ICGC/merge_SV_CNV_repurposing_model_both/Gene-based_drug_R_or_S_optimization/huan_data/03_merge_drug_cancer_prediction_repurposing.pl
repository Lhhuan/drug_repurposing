#因为prediction_repurposing.txt中没有drug cancer 的信息，所以用02_calculate_for_repo_logistic_regression_data.txt和prediction_repurposing.txt merge起来，得到./output/03_drug_cancer_prediction_repurposing.txt
#并得到预测结果为repurposing 的文件./output/03_drug_cancer_prediction_repurposing_true.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./02_calculate_for_repo_logistic_regression_data.txt";
my $f2 = "./output/prediction_repurposing.txt";
my $fo1 = "./output/03_drug_cancer_prediction_repurposing.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    if(/^Drug/){
        print $O1 "$_\trepurposing_prediction\trepurposing_prediction_value\n";
    }
    else{
        my $Drug = $f[0];
        my $cancer_oncotree_main_id =$f[1];
        my $v = "$Drug\t$cancer_oncotree_main_id";
        my $average_drug_score =$f[2];
        my $averge_gene_mutation_frequency = $f[3];
        my $average_gene_CADD_score = $f[4];
        my $average_mutation_map_to_gene_level_score = $f[5];
        my $averge_gene_num_in_del_hotspot =$f[6];
        my $averge_gene_num_in_dup_hotspot = $f[7];
        my $averge_gene_num_in_cnv_hotspot = $f[8];
        my $averge_gene_num_in_inv_hotspot = $f[9];
        my $averge_gene_num_in_tra_hotspot = $f[10];
        my $k = "$average_drug_score\t$averge_gene_mutation_frequency\t$average_gene_CADD_score\t$average_mutation_map_to_gene_level_score\t$averge_gene_num_in_del_hotspot";
        $k ="$k\t$averge_gene_num_in_dup_hotspot\t$averge_gene_num_in_cnv_hotspot\t$averge_gene_num_in_inv_hotspot\t$averge_gene_num_in_tra_hotspot";
        push @{$hash1{$k}},$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^average_drug_score/){
        my $average_drug_score = $f[0];
        my $averge_gene_mutation_frequency =$f[1];
        my $average_gene_CADD_score = $f[2];
        my $average_mutation_map_to_gene_level_score = $f[3];
        my $averge_gene_num_in_del_hotspot =$f[4];
        my $averge_gene_num_in_dup_hotspot = $f[5];
        my $averge_gene_num_in_cnv_hotspot = $f[6];
        my $averge_gene_num_in_inv_hotspot = $f[7];
        my $averge_gene_num_in_tra_hotspot = $f[8];
        my $predict = $f[9];
        my $prediction_value = $f[10];
        my $k = "$average_drug_score\t$averge_gene_mutation_frequency\t$average_gene_CADD_score\t$average_mutation_map_to_gene_level_score\t$averge_gene_num_in_del_hotspot";
        $k ="$k\t$averge_gene_num_in_dup_hotspot\t$averge_gene_num_in_cnv_hotspot\t$averge_gene_num_in_inv_hotspot\t$averge_gene_num_in_tra_hotspot";
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


my $f3 = "./output/03_drug_cancer_prediction_repurposing.txt";
my $fo2 = "./output/03_drug_cancer_prediction_repurposing_true.txt";
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