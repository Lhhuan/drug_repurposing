#将./pathogenic_hotspot/03_all_CNV_dup_del_gene.txt 和"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中的project_full_name和oncotree_id等merge到一起
#得./pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt";
my $f2 ="./pathogenic_hotspot/03_all_CNV_dup_del_gene.txt";
my $fo1 ="./pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

# my $header = "#CHROM\tBEGIN\tEND\tPROJECT\tSVSCORETOP10\tSVSCOREMAX\tSVSCORESUM\tSVSCOREMEAN\tSVTYPE\tsource\tID\tENSG\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue";
my $header = "#CHROM\tBEGIN\tEND\tPROJECT\tSVSCORETOP10\tSVSCOREMAX\tSVSCORESUM\tSVSCOREMEAN\tSVTYPE\tsource\tID\tENSG\toncotree_ID_main_tissue";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#project/){
        my $project =$f[0];
        my $oncotree_term_detail =$f[4];
        my $oncotree_ID_detail =$f[5];
        my $oncotree_term_main_tissue =$f[6];
        my $oncotree_ID_main_tissue =$f[7];
        # my $v = "$oncotree_term_detail\t$oncotree_ID_detail\t$oncotree_term_main_tissue\t$oncotree_ID_main_tissue";
        # $hash1{$project}=$v;
        $hash1{$project}=$oncotree_ID_main_tissue;
    }
}







while(<$I2>)
{
    chomp;
    my @f1= split /\t/;
    unless(/^#CHROM/){
        my $PROJECT =$f1[3];
        my @f = split/\,/,$PROJECT;
        foreach my $project(@f){
            if(exists $hash1{$project}){
                my $oncotree_ids= $hash1{$project};
                my $output = "$_\t$oncotree_ids";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}