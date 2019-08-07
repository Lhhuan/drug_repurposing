#查看./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt 中是否是直接的rwr,得./output/12_mark_positive_rwr.txt


#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;

my $f1 ="./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt";#
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/12_mark_positive_rwr.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my %hash1;
my %hash2;

while(<$I1>)
{
    chomp;
    my @f =split/\t/;
    if(/^cancer_oncotree_id_type/){
        print $O1 "$_\trwr_type\n";
    }
    else{
        my $cancer_gene_exact_match_drug_target_ratio =$f[15];
        #if ($cancer_gene_exact_match_drug_target_ratio =~/\b0\b/){
        if ($cancer_gene_exact_match_drug_target_ratio -0 <0.00000000001){
            print $O1 "$_\texact_rwr\n";
        }
        else{
             print $O1 "$_\tgene_based\n";
        }
    }
}
