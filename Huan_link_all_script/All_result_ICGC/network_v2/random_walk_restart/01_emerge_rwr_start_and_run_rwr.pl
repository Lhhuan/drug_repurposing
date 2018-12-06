#把每个drug的所有target作为group走rwr,并把结果存在parameter_optimization/top/rwr_result文件夹下面。

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
use Parallel::ForkManager; #多线程并行

# my $pm = Parallel::ForkManager->new(30); ## 设置最大的线程数目


my $f1 ="/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt";#输入的是drug target 以及repo和其gene（相当于rwr的start 和目标end）
#  my $f1 ="./123.txt";  #输入的是start和end的pair
#  my $f1 ="./12345.txt";  #输入的是start和end的pair
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my(%hash1,%hash2,%hash3,%hash7,%hash12);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug_name/){
        my $drugname = $f[0];
        my $drug_target_id = $f[3];
        my $repo = $f[4];
        my $repo_gene_id = $f[-1];
        $drugname =~s/\s+/_/g; #为了建文件夹方便，把空格替换成_
        push @{$hash1{$drugname}},$drug_target_id;
        push @{$hash2{$drugname}},$repo;
        push @{$hash3{$repo}},$repo_gene_id;
        push @{$hash12{$drugname}},$repo_gene_id; #drug 所对应的所有的repo disease gene

    }
}


foreach my $drug (sort keys %hash1){
    if(exists $hash2{$drug}){
        my $fo1 ="./parameter_optimization/top/start/${drug}.txt"; 
        open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
        my @drug_targets = @{$hash1{$drug}};
        my %hash5;
        @drug_targets = grep { ++$hash5{$_} < 2 } @drug_targets;  #对数组内元素去重
        print $O1 join"\n",@drug_targets;
        close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";
            print STDERR "$drug\n";
            #--------------------------------------------------------------------------------------------------------------#开始运行rwr并排序
        system "python run_walker.py original_network_num.txt parameter_optimization/top/start/${drug}.txt > parameter_optimization/top/rwr_result/${drug}.txt ";
        system "cat parameter_optimization/top/rwr_result/${drug}.txt | sort -k2,2rg >parameter_optimization/top/rwr_result/${drug}_sorted.txt";
    }
}
    