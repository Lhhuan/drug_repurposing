#将"/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model_both_v2/Gene-based_drug_R_or_S_optimization/side_effect_repo_data/03_unique_drug_repo_oncotree.txt"作为正样本和
#和"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/test_data/output/07_final_positive_and_negative.txt" merge到一起，
#得./output/07_final_positive_amd_negative_sample.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/test_data/output/07_final_positive_and_negative.txt";
my $f2 ="/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model_both_v2/Gene-based_drug_R_or_S_optimization/side_effect_repo_data/03_unique_drug_repo_oncotree.txt";
my $fo1 ="./output/07_final_positive_amd_negative_sample.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    print $O1 "$_\n";
}

while(<$I2>)
{
   chomp;
   my @f=split/\t/;
   unless(/^drug/){
       my $drug = $f[0];
       my $oncotree_detail_term =$f[1];
       my $oncotree_detail_ID = $f[2];
       my $oncotree_main_term =$f[3];
       my $oncotree_main_ID = $f[4];
       my $sample_type = "positive";
       my $drug_repurposing = "1";
       my $output = "$oncotree_detail_term\t$oncotree_detail_ID\t$oncotree_main_term\t$oncotree_main_ID\t$drug\t$sample_type\t$drug_repurposing";
       print $O1 "$output\n";
   }

}
