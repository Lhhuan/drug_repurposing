#把./output/01_drug_cancer_indication.txt 和"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/test_data/output/07_final_positive_and_negative.txt"
#中的负样本merge到一起，得./output/02_positive_negative_sample.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/01_drug_cancer_indication.txt";
my $f2 ="/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/test_data/output/07_final_positive_and_negative.txt";
my $fo1 ="./output/02_positive_negative_sample.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tsample_type\tdrug_repurposing";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^oncotree_term_detail/){
        print $O1 "$_\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^oncotree_term_detail/){
       my $sample_type = $f[-2];
       unless($sample_type =~/positive/){ #只用原来训练集中的负样本
           print $O1 "$_\n";
       }
    }
}