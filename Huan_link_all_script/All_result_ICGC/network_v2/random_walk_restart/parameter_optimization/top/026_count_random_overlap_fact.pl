#为025_random_overlap_fact.txt，为每个drug对应的random_overlap_fact出现的end计数，得文件026_drug_count_random_overlap_fact.txt，同时得end计数重复出现频率即normal score 文件026_drug_network_disease_gene_normal_score.txt,这个score越低，表示特异性越强


#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./025_random_overlap_fact.txt";#输入的是drug target 数目
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./026_drug_count_random_overlap_fact.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./026_drug_network_disease_gene_normal_score.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O1 "drug\trandom_overlap_fact_end\toccur_times\n";
print $O2 "drug\trandom_overlap_fact_end\tnormal_score\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    unless(/^drug/){
        my @f=split/\t/;
        my $drug = $f[0];
        my $random_overlap_fact = $f[1];
        my $k = "$drug\t$random_overlap_fact"; #把每个drug 和overlap的gene 作为key
        $hash1{$k}++;  #看$key出现的次数，
    }
}

foreach my $k (sort keys %hash1){
    my $count = $hash1{$k};
    print $O1 "$k\t$count\n";
    my $score = $count/1000;
    print $O2 "$k\t$score\n";
}

