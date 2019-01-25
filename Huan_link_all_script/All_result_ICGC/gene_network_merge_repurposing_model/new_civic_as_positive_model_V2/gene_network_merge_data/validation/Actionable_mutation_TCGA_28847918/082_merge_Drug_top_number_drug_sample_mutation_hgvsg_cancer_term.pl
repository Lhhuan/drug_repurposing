#将"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt" 中的cancer term和
# ./output/081_final_top_number_drug_sample_mutation_hgvsg.txt merge 到一起，得./output/082_merge_Drug_top_number_drug_sample_mutation_hgvsg_cancer_term.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt";
my $f2 ="./output/081_final_top_number_drug_sample_mutation_hgvsg.txt";
my $fo1 ="./output/082_merge_Drug_top_number_drug_sample_mutation_hgvsg_cancer_term.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $oncotree_term_detail = $f[4];
        my $oncotree_ID_detail = $f[5];
        my $oncotree_term_main_tissue = $f[6];
        my $oncotree_ID_main_tissue = $f[7];
        $hash1{$oncotree_ID_detail}=$oncotree_term_detail;
        $hash1{$oncotree_ID_main_tissue}=$oncotree_term_main_tissue;#把所有的id 和term都放进一个数组
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_claim_primary_name/){
        print $O1 "Oncotree_term\t$_\n";
    }
    else{
        my $oncotree_id = $f[2];
        if (exists $hash1{$oncotree_id}){
            my $Oncotree_term = $hash1{$oncotree_id} ;
            my $output ="$Oncotree_term\t$_";
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
        else{
            print STDERR "$oncotree_id\n";
        }
    }
}

