#把金标准数据，用rwr走出来的结果取0.044时overlap的结果，利用./hit_result/02_drug_hit_repo_and_gene.txt，得0211_gold_standard_overlap_rwr.txt 即用rwr top 0.044时能捕获到的金标准的数据。


#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./hit_result/02_drug_hit_repo_and_gene.txt";#输入的是drug target 数目
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./0211_gold_standard_overlap_rwr.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "cutoff\tdrug\trepo\thit_repo_gene\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    unless(/^cutoff/){
        my @f=split/\t/;
        my $cutoff = $f[0];
        if(abs($cutoff-0.044)<0.00000001){  #取cutoff为0.044 时rwr的结果
            print $O1 "$_\n";
        }
    }
}
