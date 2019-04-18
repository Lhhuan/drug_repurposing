#把./output/03_huan_drug_target_num.txt中每个文件对应的start(target)的个数统计出来，得./output/9.21_drug_target_num.txt 同时得./output/9.21_drug_num.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
#use Env qw(PATH);
# use Parallel::ForkManager; #多线程并行

# my $pm = Parallel::ForkManager->new(30); ## 设置最大的线程数目


my $f1 ="./output/03_huan_drug_target_num.txt";#输入的是drug target
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/9.21_drug_target_num.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./output/9.21_drug_num.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my %hash1;
my %hash2;
print $O1 "drug\tnum\n";


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drugname = $f[0];
        my $drug_target_id = $f[2];
        push @{$hash1{$drugname}},$drug_target_id;
    }
}


foreach my $drug (sort keys %hash1){
    my @drug_targets = @{$hash1{$drug}};
    my %hash5;
    @drug_targets = grep { ++$hash5{$_} < 2 } @drug_targets;  #对数组内元素去重
    my $num = @drug_targets;
    print $O1 "$drug\t$num\n";
    $hash2{$num}=1;
}

foreach my $num(sort keys %hash2){
    print $O2 "$num\n";
}