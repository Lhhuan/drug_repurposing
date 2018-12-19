
# 将./output/05_logistic_regression_prediction_potential_drug_repurposing_data.txt predict 是1的筛选出来
# 得文件"./output/06_drug_cancer_prediction_potential_drug_repurposing.txt"

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use Math::BigFloat;


my $f3 = "./output/05_logistic_regression_prediction_potential_drug_repurposing_data.txt";
my $fo2 = "./output/06_drug_cancer_prediction_potential_drug_repurposing.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    if(/^Drug/){
        print $O2 "$_\n";
    }
    else{
        my $score = $f[-2];
        if ($score>0){#也就是等于1
            print $O2 "$_\n";
        }
    }
}