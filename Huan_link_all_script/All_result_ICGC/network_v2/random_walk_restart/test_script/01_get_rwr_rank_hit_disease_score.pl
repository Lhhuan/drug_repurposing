#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
use Parallel::ForkManager; #多线程并行

# my $pm = Parallel::ForkManager->new(30); ## 设置最大的线程数目


my $f1 ="/f/mulinlab/huan/All_result/network/rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt";#输入的是drug target 以及repo和其gene（相当于rwr的start 和目标end）
# #  my $f1 ="./123.txt";  #输入的是start和end的pair
#  my $f1 ="./12345.txt";  #输入的是start和end的pair
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my(%hash1,%hash2,%hash3,%hash6,%hash7);

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
        #my $repo_info = "$repo\t$repo_gene_id";
        #print STDERR "$drugname\n";
        push @{$hash1{$drugname}},$drug_target_id;
        push @{$hash2{$drugname}},$repo;
        push @{$hash3{$repo}},$repo_gene_id;

    }
}
#---------------------  #设置cutoff的范围
my @score_cutoff;
for (my $i = 0.1;$i<0.7;$i=$i+0.01){ #构造参数score_cutoff的数组，
    $i= sprintf("%.2f", $i);  #因为计算机的存储不准确，所以四舍五入取两位小数。
    # print STDERR "$i\n";
    push @score_cutoff,$i;  
}
#----------------
my $fo2 ="./parameter_optimization/score/hit_result/drug_repo_gene_result.txt"; #最终输出结果文件
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";  
print $O2 "cutoff\tdrug\tID\trepo\n";
my $fo3 ="./parameter_optimization/score/hit_result/drug_repo_gene_count_ratio_result.txt"; #最终输出结果文件
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
print $O3 "cutoff\tdrug\trepo\thitcount\tgenecount\thit_ratio\n";
my $fo4 ="./parameter_optimization/score/hit_result/drug_repo_hit_count_result.txt"; #最终输出结果文件
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
print $O4 "cutoff\tdrug\tall_repo_count\thit_hit_repo_count\tnot_hit_count\n";
#-------------------------------------------------------------------------------


 my @hit_counts; #hit repo gene的count
 my @hit_count_repos; #hit repo diseases 的count
foreach my $drug (sort keys %hash1){
    if(exists $hash2{$drug}){
        my $fo1 ="./parameter_optimization/score/start/${drug}.txt"; 
        open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
        # select $O1;
        my @repos = @{$hash2{$drug}};
        my %hash4;
        @repos = grep { ++$hash4{$_} < 2 } @repos;  #对数组内元素去重
        # print STDERR join"\n",@repos;
        # print STDERR "#######################123\n\-----------------------\n";
        #------------------------------------------------------------------------#构造rwr的start
        my @drug_targets = @{$hash1{$drug}};
        my %hash5;
        @drug_targets = grep { ++$hash5{$_} < 2 } @drug_targets;  #对数组内元素去重
        print $O1 join"\n",@drug_targets;
        close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";
        # print STDERR "$drug\n";
        #--------------------------------------------------------------------------------------------------------------#开始运行rwr并排序
        system "python run_walker.py original_network_num.txt parameter_optimization/score/start/${drug}.txt > parameter_optimization/score/rwr_result/${drug}.txt ";
        system "cat parameter_optimization/score/rwr_result/${drug}.txt | sort -k2,2rg >parameter_optimization/score/rwr_result/${drug}_sorted.txt";
        #--------------------------------------------------------------------------------------------------------------------------------
        # my $fo2 ="./parameter_optimization/hit_result/drug_repo_gene_result.txt"; #最终输出结果文件
        # open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
        
        # print $O2 "cutoff\tdrug\tID\trepo\n";
        # my $fo3 ="./parameter_optimization/hit_result/drug_repo_gene_count_ratio_result.txt"; #最终输出结果文件
        # open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
        
        # print $O3 "cutoff\tdrug\trepo\thitcount\tgenecount\thit_ratio\n";
        # #-------------------------------------------------------------------------------
        my $f2 ="./parameter_optimization/score/rwr_result/${drug}_sorted.txt";  
        open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";

        foreach my $cutoff(@score_cutoff){
            # print STDERR "$cutoff\n";
            #   my $fo2 ="./parameter_optimization/hit_result/result.txt"; #最终输出结果文件
            #   open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
            while(<$I2>){
                chomp;
                my @f = split/\t/;
                my $ID =$f[0];
                my $score = $f[1];
                if($score >=$cutoff){
                        $hash6{$ID}=$score; 
                }
            }
            #--------------------------------------------
            my $all_repo_count = @repos ;#所有的已知的repo 的计数
            foreach my $repo(@repos){
                # print STDERR "$drug\t$repo\n";
                        # print STDERR "$repo\t$score\t####\n";
                if(exists$hash3{$repo}){
                    my @genes= @{$hash3{$repo}};
                    my %hash10;
                    @genes = grep { ++$hash10{$_} < 2 } @genes;  #对数组内元素去重
                    my $genecount = @genes;# 所有的repo gene的count;
                    foreach my $ID (sort keys %hash6){
                        my $score = $hash6{$ID};
                            foreach my $gene(@genes){
                                # print STDERR "$drug\t$repo\n";
                                if ($ID == $gene){
                                    #  print STDERR "$drug\t$repo\n";
                                    push @hit_counts,$ID;
                                    # print STDERR "12345\n";
                                    my %hash9;
                                    my $out_repo = "$cutoff\t$drug\t$ID\t$repo";
                                    unless(exists $hash9{$out_repo}){
                                        print $O2 "$out_repo\n";
                                        $hash9{$out_repo}=1;
                                    }
                                    push @hit_count_repos,$repo;
                                }
                            }
                    }
                    my $hitcount = @hit_counts;
                    my $hit_ratio = $hitcount/$genecount;
                    # unless($hit_ratio ==0 ){
                        print $O3 "$cutoff\t$drug\t$repo\t$hitcount\t$genecount\t$hit_ratio\n";
                    # }
                    @hit_counts =();#清空数组
                }
                
            }
            my %hash8;
             @hit_count_repos = grep { ++$hash8{$_} < 2 } @hit_count_repos;
             my $hit_hit_repo_d  = @hit_count_repos;
             my $not_hit = $all_repo_count - $hit_hit_repo_d;
             print $O4 "$cutoff\t$drug\t$all_repo_count\t$hit_hit_repo_d\t$not_hit\n";   #输出hit和没有hit的count
             @hit_count_repos = ();

        }
        
    }
}




 