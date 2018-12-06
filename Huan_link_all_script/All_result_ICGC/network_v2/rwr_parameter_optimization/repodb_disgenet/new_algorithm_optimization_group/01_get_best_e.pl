#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
use Parallel::ForkManager; #多线程并行

# my $pm = Parallel::ForkManager->new(30); ## 设置最大的线程数目

 my $f1 ="../06_test_start_end_num_sorted.txt";  #输入的是start和end的pair
#  my $f1 ="./123.txt";  #输入的是start和end的pair
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
 chomp;
    unless(/^drug_name/){
        my @f= split /\t/;
        my $drug = $f[0];
        my $drug_terget = $f[1];
        my $repo_disease = $f[2];
        my $disease_gene = $f[3];
        push@{$hash1{$drug}},$drug_terget;
        push@{$hash2{$drug}},$disease_gene;
    }
}
my @es;
for (my$i = 0.5;$i<0.9;$i=$i+0.1){ #构造参数e的数组，从0.5开始，以0.1为步长，一直增加到0.9
    #$i= $i+10;
    push @es,$i;  
}

foreach my $e_p(@es){
         my $fo2 ="./start_end_pro/result_restart${e_p}.txt"; 
         open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";#overlap结果的的输出文件
foreach my $drug (sort keys %hash1){
    if(exists$hash2{$drug}){
        my @drug_tergets= @{$hash1{$drug}};
        my @disease_genes= @{$hash2{$drug}};
        #---------------------------------------------#删除数组内的重复元素
        my %saw; 
        @saw{ @drug_tergets } = ( );
        my @uniq_drug_tergets = sort keys %saw; 
        my %dig; 
        @dig{ @disease_genes } = ( );
        my @uniq_disease_genes = sort keys %dig; 
        #--------------------------------------#构建start文件，把一个drug的所有target的集合作为rwr的起点
        my $fo1 ="./test_start/$drug.txt"; 
        open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
        select $O1;
        print $O1 join "\n",@uniq_drug_tergets;  #以"\n"分割输出数组
        close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
        #------------------------------------------------------------
        
         #对每个restart probability 进行循环
        # my $e_p = 0.7;
            #----------------------------------------------------------------------------------------------#计算rwr
            $ENV{'epp'} = $e_p ;#声明环境变量，方便下面传给python脚本
            system "python run_walker.py /f/mulinlab/huan/All_result/network/original_network_num.txt test_start/$drug.txt >teat_result/${drug}_${e_p}result.txt -e $e_p"; #把rwr的结果定向到文件中
            #-------------------------------------------------------------------------------------------------
            my $f2 ="teat_result/${drug}_${e_p}result.txt"; 
            open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
            while(<$I2>)
            {
            chomp;
            my @f= split /\t/;
            my $end = $f[0];
            my $probilaty = $f[1];
            # my @ends =@{$hash1{$start}};
                foreach my $disease_gene(@uniq_disease_genes){
                    if ($end==$disease_gene){
                        print $O2 "$drug\t$end\t$probilaty\n";
                    }
                }
            }
        }
    }
}










