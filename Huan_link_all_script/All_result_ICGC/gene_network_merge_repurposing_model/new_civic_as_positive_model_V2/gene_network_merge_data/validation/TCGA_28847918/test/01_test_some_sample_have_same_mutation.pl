# 查看./output/sample.txt 在../output/06_filter_snv_in_icgc.txt和../output/07_filter_snv_in_huan.txt中hit住的mutation ID 
#得./output/01_overlap_with_06_icgc.txt 和./output/01_overlap_with_07_huan.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/sample.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "/f/mulinlab/huan/All_result_ICGC/pathogenicity_mutation_cancer/pathogenicity_15_occur_more_than2.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 = "../output/06_filter_snv_in_icgc.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $f4 = "../output/07_filter_snv_in_huan.txt";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";

my $fo1 = "./output/01_overlap_with_06_icgc.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/01_overlap_with_07_huan.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 = "./output/01_overlap_06_NOT_07_overlap_with_pathogenicity_15_occur_more_than2.txt";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

# print $O1 "sample\tchr\tstart\tend\treference\talt\tgene\teffect\tDNA_VAF\tRNA_VAF\tAmino_Acid_Change\tproject\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\n";
# print $O2 "sample\tchr\tstart\tend\tvalue\tproject\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\n";


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    my $sample = $f[4];
    $hash1{$sample}=1;
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    my $Mutation_id = $f[0];
    $hash4{$Mutation_id}=1;
}

while(<$I3>)
{
    chomp;
    unless(/^Drug_chembl_id/){
        my @f= split/\t/;
        my $sample = $f[2];
        my $Mutation_id = $f[-1];
        if (exists $hash1{$sample}){
            my $output = "$sample\t$Mutation_id";
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
            unless ($Mutation_id =~/MU62030|MU4553606/){
                if (exists $hash4{$Mutation_id}){
                    my $output = $Mutation_id;
                    unless (exists $hash5{$output}){
                        $hash5{$output} =1;
                        print $O3 "$output\n";
                    }
                }
            }
        }
    }
}

while(<$I4>)
{
    chomp;
    unless(/^Drug_chembl_id/){
        my @f= split/\t/;
        my $sample = $f[-1];
        my $Mutation_id = $f[2];
        if (exists $hash1{$sample}){
            my $output = "$sample\t$Mutation_id";
            unless(exists $hash3{$output}){
                $hash3{$output} =1;
                print $O2 "$output\n";
            }
        }
    }
}
