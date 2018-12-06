#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
use POSIX;

#my $f1 ="/f/mulinlab/huan/All_result/network/rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt";#输入的是drug target 以及repo和其gene（相当于rwr的start 和目标end）
my $f1 ="../rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt";#输入的是drug target 以及repo和其gene（相当于rwr的start 和目标end）
 #my $f1 ="./123434.txt";  #输入的是start和end的pair
#  my $f1 ="./12345.txt";  #输入的是start和end的pair
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my(%hash1,%hash2,%hash3,%hash7,%hash12);

my $fo1 ="./parameter_optimization/top/hit_result/drug_hit_all_repo_gene_count_result_test2.txt"; ##最终输出结果文件 每个drug hit 到的所有的repo disease gene
#my $fo1 ="./parameter_optimization/top/hit_result/drug_hit_all_repo_gene_count_result.txt"; ##最终输出结果文件 每个drug hit 到的所有的repo disease gene
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "cutoff\tdrug\tall_count_gene\thit_gene_count\tnot_hit_gene\tline2\tture_line\n";


# my $fo2 = "./top_genes.txt";
# open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

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
        push @{$hash12{$drugname}},$repo_gene_id; #drug 所对应的所有的repo disease gene
    }
}
close $I1 or warn "$0 : failed to close output file '$f1' : $!\n";

my @top_cutoff;
for (my$i = 0.0001;$i<0.1001;$i=$i+0.0001){ #构造参数top_cutoff的数组，
    #$i= $i+10;
     $i= sprintf("%.4f", $i);  #因为计算机的存储不准确，所以四舍五入取四位小数。
    push @top_cutoff,$i;  
}

foreach my $drug (sort keys %hash1){
     foreach my $cutoff(@top_cutoff){
        my $line = 12277*$cutoff;
        my $line2  = sprintf "%.f", $line; # 这个是四舍五入取整
                # print STDERR "$line2\n";
        system "head -n $line2 parameter_optimization/top/rwr_result/${drug}_sorted.txt | tail -n 1 |cut -f 2 >score_cutoff1.txt";  #把top转成cutoff
     # #-------------------------------------------------------------------------------
        my $f2 ="./parameter_optimization/top/rwr_result/${drug}_sorted.txt";  
        open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
        my $f3 ="./score_cutoff1.txt";  
        open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
        my %hash6;
        my @all;
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
                if($top >$score){
                   #print "$drug\t$ID\t$score\n";
                    #$hash6{$ID}=$top; 
                    push @{$hash6{$top}},$ID;
                    push @all,$ID;
                }
                elsif(abs($top -$score) <0.0000000001){
                     push @{$hash6{$top}},$ID;
                    push @all,$ID;
                }
            }
          }
          close $I2 or warn "$0 : failed to close output file '$f2' : $!\n";
          close $I3 or warn "$0 : failed to close output file '$f3' : $!\n";
          my $ccc = @all;
          #----------------------------------
        #    print $O2 join "\t",@all;
        #   print $O2 "\n";
          #------------------------------
          @all =();
#----------------------------------------------------------拿每个drug的所有repo-gene并去重
        my @all_repo_gene = @{$hash12{$drug}};
        my %hash13;
        @all_repo_gene = grep { ++$hash13{$_} < 2 } @all_repo_gene;
        my $all_repo_genes = @all_repo_gene;
        my @hit_gene;
#---------------------------------------------------------
        foreach my $repo_gene(@all_repo_gene){
            foreach my $top (sort keys %hash6){
                my @ids= @{$hash6{$top}};
                foreach my $id(@ids){
                    if (abs($id-$repo_gene)<0.000001){
                        push @hit_gene,$id;
                    }
                        #print "$top\t$id\n";
                }
            } 
        }
        my $all_count = @all_repo_gene;
        my $hit_count = @hit_gene;
        my $not_hit = $all_count - $hit_count;
        print STDERR "$cutoff\n";
        print $O1 "$cutoff\t$drug\t$all_count\t$hit_count\t$not_hit\t$line2\t$ccc\n";
         @hit_gene = ();     
     }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";