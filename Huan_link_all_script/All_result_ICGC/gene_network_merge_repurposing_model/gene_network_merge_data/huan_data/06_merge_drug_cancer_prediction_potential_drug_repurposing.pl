#因为./output/05_logistic_regression_prediction_potential_drug_repurposing_data.txt中没有drug cancer 的信息，
#所以用"./output/04_calculate_features_for_logistic_regression.txt"和./output/05_logistic_regression_prediction_potential_drug_repurposing_data.txt merge起来，
#并得到merge的文件./output/06_merge_drug_cancer_prediction_potential_drug_repurposing.txt
##并得到预测结果为repurposing 的文件"./output/06_drug_cancer_prediction_potential_drug_repurposing.txt"

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use Math::BigFloat;

my $f1 = "./output/04_calculate_features_for_logistic_regression.txt";
my $f2 = "./output/05_logistic_regression_prediction_potential_drug_repurposing_data.txt";
my $fo1 = "./output/06_merge_drug_cancer_prediction_potential_drug_repurposing.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug = $f[0];
        my $cancer_oncotree_main_id =$f[1];
        my $v = "$Drug\t$cancer_oncotree_main_id";
        my $k =join("\t",@f[2..14]);
        push @{$hash1{$k}},$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    if(/^average/){
        print $O1 "Drug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\t$_\n";
    }
    else{
        my $i =$f[6];
        $i = new Math::BigFloat $i; #把科学计数法转换成浮点数
        my $k = join("\t",@f[0..5],$i,@f[7..12]);
        my $predict = $f[13];
        my $prediction_value = $f[14];
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
    else{
        print STDERR "$features\n";
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄


my $f3 = "./output/06_merge_drug_cancer_prediction_potential_drug_repurposing.txt";
my $fo2 = "./output/06_drug_cancer_prediction_potential_drug_repurposing.txt";
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