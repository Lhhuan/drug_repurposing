#对./output/filter_top_gene_by_score.txt 从./output/merge_gene_based_and_network_based_data_for_figure.txt中提取相关信息，得./output/recall_top_gene_by_score_info.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/filter_top_gene_by_score.txt";
my $f2 = "./output/merge_gene_based_and_network_based_data_for_figure.txt";
my $fo1 = "./output/recall_top_gene_by_score_info.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Drug_chembl_id_Drug_claim_primary_name\tdata_source\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\n";
my %hash1;
my %hash2;


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $data_source = $f[1];
        my $drug_ENSG = $f[3];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$data_source\t$drug_ENSG"; #这样可以将gene based 和network based区分开
        $hash1{$k}=1;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug_ENSG = $f[2];
        my $drug_target_score = $f[3];
        my $oncotree_term_detail = $f[13];
        my $oncotree_ID_detail =$f[14];
        my $oncotree_term_main_tissue =$f[15];
        my $oncotree_ID_main_tissue = $f[16];
        my $data_source = $f[-1];
        my $output = "$Drug_chembl_id_Drug_claim_primary_name\t$data_source\t$oncotree_term_detail\t$oncotree_ID_detail\t$oncotree_term_main_tissue\t$oncotree_ID_main_tissue";
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$data_source\t$drug_ENSG"; #这样可以将gene based 和network based区分开
        if(exists $hash1 {$k}){
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
    }
}

