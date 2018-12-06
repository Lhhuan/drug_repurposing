#把./output/cancer_from_repoDB_approved.txt 和./output/unique_cancer_term_from_repoDB_approved_oncotree.txt merge 在一起，得./output/001_merge_repoDB_oncotree.txt
#把临床前re


#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my $f1 ="./output/cancer_from_repoDB_approved.txt";
my $f2 ="./output/unique_cancer_term_from_repoDB_approved_oncotree.txt";
my $fo1 ="./output/001_merge_repoDB_oncotree.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "drug_name\tstatus\toncotree_main_tissue_id\tcancer_disease\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug_name/){
        my $drug_name= $f[0];
        my $disease = $f[1];
        my $status = "Indication";  #本来是Approved
        my $v= "$drug_name\t$status";
        push @{$hash1{$disease}},$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Cancer/){
        my $Cancer= $f[0];
        my $oncotree_main_tissue_id = $f[1];
        unless($oncotree_main_tissue_id =~/NA/){
            $hash2{$Cancer}=$oncotree_main_tissue_id;
        }
    }
}

foreach  my $cancer(sort keys %hash1){
    my @drug_infos = @{$hash1{$cancer}};
    if (exists $hash2{$cancer}){
        my $oncotree_main_tissue_id = $hash2{$cancer};
        foreach my $drug_info(@drug_infos){
            my $output = "$drug_info\t$oncotree_main_tissue_id\t$cancer";
            unless (exists $hash3{$output}){
                $hash3{$output} =1;
                print $O1 "$output\n";
            } 
        }
    }
}


