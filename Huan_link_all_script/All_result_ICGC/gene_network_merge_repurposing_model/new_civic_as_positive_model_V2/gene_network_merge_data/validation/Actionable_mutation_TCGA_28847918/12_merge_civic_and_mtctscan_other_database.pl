# 把./output/11_civic_sensitivity_oncotree_deal_drug.txt 和../gdkb_cgi_oncokb_mtctscan/output/02_merge_mtctscan_all_sensitivity_oncotree.txt 中的非civic来源的sensitivity
#merge 到一起，得./output/12_merge_civic_and_mtctscan_other_database.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my $f1 ="./output/11_civic_sensitivity_oncotree_deal_drug.txt";
my $f2 ="../gdkb_cgi_oncokb_mtctscan/output/02_merge_mtctscan_all_sensitivity_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/12_merge_civic_and_mtctscan_other_database.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1, %hash2 ,%hash3, %hash4);

my $output ="oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tdisease\tclinical_significance\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt";
$output = "$output\tentrez_id\tdrug_interaction_type\tstd_mutation_super_class\tsource";
print  $O1 "$output\n";


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^oncotree_term_detail/){
      print $O1 "$_\tNA\tCivic\n";
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^drug_name/){
        my $oncotree_detail_term = $f[-4];
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_term = $f[-2];
        my $oncotree_main_ID = $f[-1];
        my $drug= $f[0];
        my $disease = $f[16];
        my $clinical_significance = $f[13];
        my $std_implication_result = $f[13];
        my $gene  = $f[6];
        my $variant = $f[9];
        my $evidence_statement = $f[15];
        my $variant_id = "NA";
        my $chr = $f[1];
        my $start = $f[2];
        my $end = $f[3];
        my $ref = $f[4];
        my $alt = $f[5];
        my $entrez_id = "NA";
        my $drug_interaction_type = "NA";
        my $source = $f[19];
        my $version = $f[20];
        my $final_source = "mtctscan_${version}_$source";
        my $implication_result = $f[12];
        my $std_mutation_super_class =  $f[10];
        my $output = "$oncotree_detail_term\t$oncotree_detail_ID\t$oncotree_main_term\t$oncotree_main_ID\t$drug\t$disease\t$clinical_significance\t$gene\t$variant\t$evidence_statement\t$variant_id";
        $output = "$output\t$chr\t$start\t$end\t$ref\t$alt\t$entrez_id\t$drug_interaction_type\t$std_mutation_super_class\t$final_source";
        unless($source =~/civic/i){
            print $O1 "$output\n";
       }
    }
}
