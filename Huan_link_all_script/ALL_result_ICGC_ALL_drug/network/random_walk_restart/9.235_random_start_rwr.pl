#以./huan_data_rwr/random_select/start/${num}/start${i}.txt 为起点走rwr,结果为./huan_data_rwr/random_select/rwr_result/${num}/result${i}.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;

my $f1 ="./output/9.215_drug_num.txt";#输入的是drug target
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";

my %hash1;
my %hash2;

while(<$I1>)
{
    chomp;
    my $num = $_;
    my $dir = "./output/huan_data_rwr/random_select/rwr_result/${num}";
    mkdir $dir unless -d $dir; #建文件夹
    for(my $i=1; $i<1001;$i++){# 给你 random 取1000 个看看 
        my $f2 ="./output/huan_data_rwr/random_select/start/${num}/start${i}.txt";#输入的是drug target
        system "python run_walker.py ./output/original_network_num.txt $f2 > ./output/huan_data_rwr/random_select/rwr_result/${num}/result${i}.txt";
        system "cat ./output/huan_data_rwr/random_select/rwr_result/${num}/result${i}.txt | sort -k2,2rg >  ./output/huan_data_rwr/random_select/rwr_result/${num}/result${i}_sorted.txt";
    }
}


