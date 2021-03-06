#把./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt 和./output/06_random_select_2_fold_negative.txt merge在一起，得./output/07_merge_negative_positive.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;

my $f1 ="./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt";#
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./output/06_random_select_2_fold_negative.txt";#
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/07_merge_negative_positive.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my @positives;
while(<$I1>)
{
    chomp;
    if(/^cancer_oncotree_id_type/){
        print $O1 "$_\tsample_type\n";
    }
    else{
        my $output = "$_\t1";
        push @positives,$output;
    }
}
for(my $i=1; $i<11;$i++){ #输出10遍，和随机选取10遍相对应
    foreach my $positive(@positives){
        print $O1 "$positive\n";
    }
}

while(<$I2>)
{
    chomp;
    unless(/^cancer_oncotree_id_type/){
        print $O1 "$_\t0\n";
    }
}
