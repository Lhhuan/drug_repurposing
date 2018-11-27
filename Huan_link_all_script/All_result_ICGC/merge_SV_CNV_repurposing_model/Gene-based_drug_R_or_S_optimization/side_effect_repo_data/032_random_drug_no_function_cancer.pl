#把031_emerge_drug_no_function_with_cancer.txt，从"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中随机选出药物对应的cancer作为负样本。得032_random_drug_no_function_cancer.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./031_emerge_drug_no_function_with_cancer.txt";
my $f2 = "/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt";
my $fo1 = "./032_random_drug_no_function_cancer.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    $hash1{$_}=1;
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    my $cancer = $f[-1];
    $hash2{$cancer}=1;
}

foreach my $drug (sort keys %hash1){
    foreach my $cancer(sort keys %hash2){
        print $O1 "$drug\t$cancer\n";
    }
}