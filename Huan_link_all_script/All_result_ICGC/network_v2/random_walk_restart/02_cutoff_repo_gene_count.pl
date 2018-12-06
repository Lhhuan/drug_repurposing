# #cutoff 取top 0.0001-0.1时，每个cutoff时，drug所对应的每个repo rwr结果hit住每个drug repo的disease gene的个数，得文件"./parameter_optimization/top/hit_result/02_drug_hit_repo_and_gene.txt";
##在不同cutoff下，rwr结果hit住repo 时，hit住几个基因，并算出要做Fisher exact test时所需的ABC


#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;

#my $f1 ="/f/mulinlab/huan/All_result/network/rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt";#输入的是drug target 以及repo和其gene（相当于rwr的start 和目标end）
my $f1 ="../rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt";#输入的是drug target 以及repo和其gene（相当于rwr的start 和目标end）
#  my $f1 ="./test.txt";  #输入的是start和end的pair
#  my $f1 ="./12345.txt";  #输入的是start和end的pair
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my(%hash1,%hash2);

my $fo1 ="./parameter_optimization/top/hit_result/02_drug_hit_repo_and_gene.txt"; #最终输出结果文件,在不同的cutoff下，rwr结果hit住每个drug repo的disease gene的个数
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "cutoff\tdrug\trepo\thit_repo_gene\n";

my $fo2 ="./parameter_optimization/top/hit_result/02_drug_hit_repo_and_gene-count_prepare_fisher.txt"; #在不同cutoff下，rwr结果hit住repo 时，hit住几个基因，并算出要做Fisher exact test时所需的ABC
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O2 "cutoff\tdrug\trepo\tgene_score_large_than_cutoff_count\trepo_gene_large_than_cutoff__A\tno_repo_gene_large_than_cutoff__B\tall_repo_gene\tC\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug_name/){
        my $drugname = $f[0];
        my $drug_target_id = $f[3];
        my $repo = $f[4];
        my $repo_gene_id = $f[-1];
        $repo =~s/\s+/_/g;
        $drugname =~s/\s+/_/g; #为了建文件夹方便，把空格替换成_
         my $k = "$drugname\t$repo";
        #  print STDERR "$k\n";
        push @{$hash1{$k}},$repo_gene_id;
    }
}

my @top_cutoff;
#for (my$i = 0.0001;$i<0.0002;$i=$i+0.0001){ #构造参数top_cutoff的数组，
for (my$i = 0.0001;$i<0.1001;$i=$i+0.0001){ #构造参数top_cutoff的数组，
    #$i= $i+10;
     $i= sprintf("%.4f", $i);  #因为计算机的存储不准确，所以四舍五入取四位小数。
    push @top_cutoff,$i;  
}

#
foreach my $k (sort keys %hash1){
    my @dr = split/\t/,$k;
    my $drug = $dr[0];
    my $repo = $dr[1];
     foreach my $cutoff(@top_cutoff){
        my $line = 12277*$cutoff;
        my $line2  = sprintf "%.f", $line; # 这个是四舍五入取整
                # print STDERR "$line2\n";
        system "head -n $line2 parameter_optimization/top/rwr_result/${drug}_sorted.txt | tail -n 1 |cut -f 2 >score_cutoff.txt";  #把top转成cutoff
     # #-------------------------------------------------------------------------------
        my $f2 ="./parameter_optimization/top/rwr_result/${drug}_sorted.txt";  
        open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
        my $f3 ="./score_cutoff.txt";  
        open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
        my %hash6;
        my @top_genes;
        while(<$I3>){
            chomp;
            my $score = $_;  
            $score = sprintf("%.6f", $score); 
    #--------------------------------------------------------------------读rwr的结果，把大于最低cutoff score 的id push进数组。
            while(<$I2>){
                chomp;
                my @f = split/\t/;
                my $ID =$f[0];
                my $top = $f[1];
                $top = sprintf("%.6f", $top); 
                if($top>$score && $top>0.00001){
                    push @top_genes,$ID;#把score大于cutoff的gene push 进数组
                }
                elsif(abs($top -$score) <0.0000000001 && $top>0.00001){
                    push @top_genes,$ID; 
                }
            }
          }
          close $I2 or warn "$0 : failed to close output file '$f2' : $!\n";
          close $I3 or warn "$0 : failed to close output file '$f3' : $!\n";
    #----------------------------------------------------------maprepo gene 和score>cutoff 的gene取交集
        my @genes = @{$hash1{$k}};
        my $all_top_gene = @top_genes; #所有的cutoff以上的gene个数
        my @hit_gene;
        my %hash4;
        @genes = grep { ++$hash4{$_} < 2 } @genes;
        my $all_disease_gene = @genes;

        foreach my $gene(@genes){   #--------------------------------------------------------------
            foreach my $id(@top_genes){
                if ($id==$gene){
                    my $output = "$cutoff\t$k\t$gene";
                    unless(exists$hash2{$output}){
                        print $O1 "$output\n";
                        $hash2{$output} = 1;
                    }
                    push@hit_gene,$gene;#把hit住的gene push进数组
                }
            }
        }
        my %hash3;
        @hit_gene = grep { ++$hash3{$_} < 2 } @hit_gene; #对数组元素进行去重，
        my $hit_gene_count = @hit_gene;   
        my $A = $hit_gene_count;
        my $not_hit_disease_gene = $all_disease_gene - $hit_gene_count;
        my $C= $not_hit_disease_gene;
        my $B = $all_top_gene - $hit_gene_count;
        my $output2 = "$cutoff\t$k\t$all_top_gene\t$hit_gene_count\t$B\t$all_disease_gene\t$C";
        print $O2 "$output2\n";
     }
}
