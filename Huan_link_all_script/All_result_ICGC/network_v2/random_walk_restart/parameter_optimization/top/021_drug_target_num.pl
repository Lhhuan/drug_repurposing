#统计"/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt"中drug target的数目。
#得021_drug_target_num.txt,得target :021_target_num.txt,同时得drug及target的信息，得文件021_drug_target.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt";#输入的是drug target 以及repo和其gene（相当于rwr的start 和目标end）
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./021_drug_target_num.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "drug\tdrug_target_num\n";
my $fo2 ="./021_target_num.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 ="./021_drug_target.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
print $O3 "drug_name\tdrug_target_id_network\n";
my %hash1;
my %hash2;
my %hash3;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug_name/){
        my $drugname = $f[0];
        my $drug_target_id = $f[3];
        my $end_id = $f[7];
        $drugname =~s/\s+/_/g; #为了建文件夹方便，把空格替换成_
        push @{$hash1{$drugname}},$drug_target_id;
        my $k= "$drugname\t$drug_target_id";
        unless (exists $hash3{$k}){
            $hash3{$k} =1;
            print $O3 "$k\n";
        }
    }
}


foreach my $drug (sort keys %hash1){
    my @drug_targets = @{$hash1{$drug}};
    my %hash5;
    @drug_targets = grep { ++$hash5{$_} < 2 } @drug_targets;  #对数组内元素去重
    my $target_num = @drug_targets;
    print $O1 "$drug\t$target_num\n";
    unless ($hash2{$target_num}){
        $hash2{$target_num} =1;
        print $O2 "$target_num\n";
    }
}