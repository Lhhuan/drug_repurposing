#把02_repo_cancer_oncotree.txt中oncotree term 不是NA的，和02_repo_cancer.txt merge 到一起，得03_filter_drug_repo_cancer_oncotree.txt,得drug和repo oncotree的unique pair 03_unique_drug_repo_oncotree.txt 

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./02_repo_cancer_oncotree.txt";
my $f2 ="./02_repo_cancer.txt";
my $fo1 ="./03_filter_drug_repo_cancer_oncotree.txt"; 
my $fo2 ="./03_unique_drug_repo_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O1 "drug\trepo_cancer\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\n";
print $O2 "drug\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^repo_cancer/){
        my $repo= $f[0];
        my $repo_oncotree_detail_term = $f[1];
        my $repo_oncotree_detail_ID = $f[2];
        my $repo_oncotree_main_term = $f[3];
        my $repo_oncotree_main_ID = $f[4];
        unless($repo_oncotree_detail_term =~/NA/){
            my $v = join("\t",@f[1..4]);
            $hash1 {$repo}=$v;
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug_name/){
        my $drug= $f[0];
        my $repo = $f[3];
        push @{$hash2{$repo}},$drug;
    }
}


foreach my $repo(sort keys %hash1){
    my $cancer_oncotree_info = $hash1{$repo};
    if(exists $hash2{$repo}){
        my @drugs = @{$hash2{$repo}};
        foreach my $drug(@drugs){
            my $output = "$drug\t$repo\t$cancer_oncotree_info";
            unless(exists $hash3{$output}){
                $hash3{$output} =1;
                print $O1 "$output\n";
            }
            my $output2 = "$drug\t$cancer_oncotree_info";
            unless(exists $hash4{$output2}){
                $hash4{$output2} =1;
                print $O2 "$output2\n";
            }
        }
    }
}