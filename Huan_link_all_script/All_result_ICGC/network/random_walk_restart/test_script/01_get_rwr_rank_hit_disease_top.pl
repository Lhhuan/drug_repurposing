#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
use Parallel::ForkManager; #多线程并行

# my $pm = Parallel::ForkManager->new(30); ## 设置最大的线程数目


# my $f1 ="/f/mulinlab/huan/All_result/network/rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt";#输入的是drug target 以及repo和其gene（相当于rwr的start 和目标end）
# #  my $f1 ="./123.txt";  #输入的是start和end的pair
 my $f1 ="./12345.txt";  #输入的是start和end的pair
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my(%hash1,%hash2,%hash3,%hash6,%hash7,%hash12);

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
        push @{$hash12{$drugname}},$repo_gene_id; #drug 所对应的所有的repo disease gene

    }
}
#---------------------  #设置cutoff的范围
my @top_cutoff;
# for (my$i = 0.2;$i<0.5;$i=$i+0.2){ #构造参数top_cutoff的数组，
for (my$i = 0.0001;$i<0.1001;$i=$i+0.0001){ #构造参数top_cutoff的数组，
    #$i= $i+10;
     $i= sprintf("%.4f", $i);  #因为计算机的存储不准确，所以四舍五入取四位小数。
    push @top_cutoff,$i;  
}
#----------------
my $fo2 ="./parameter_optimization/top/hit_result/drug_repo_gene_result.txt"; #最终输出结果文件 #每个drug hit 到disease 时，所hit到的gene
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";  
print $O2 "cutoff\tdrug\tID\trepo\n";
my $fo3 ="./parameter_optimization/top/hit_result/drug_repo_gene_count_ratio_result.txt"; #最终输出结果文件
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
print $O3 "cutoff\tdrug\trepo\thit_gene_count\tall_gene_genecount\thit_ratio\n"; #每个的drug,对每个repo而言，hit 到的gene个数，以及占所有disease gene的比例
my $fo4 ="./parameter_optimization/top/hit_result/drug_repo_hit_count_result.txt"; #最终输出结果文件,hit 到的repo count 
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
print $O4 "cutoff\tdrug\tall_repo_disease_count\thit_repo_count\tnot_hit_count\n";
my $fo5 ="./parameter_optimization/top/hit_result/drug_hit_all_repo_gene_count_result.txt"; #最终输出结果文件 每个drug hit 到的所有的repo disease gene
open my $O5, '>', $fo5 or die "$0 : failed to open output file '$fo5' : $!\n";
print $O5 "cutoff\tdrug\tall_repo_genes\tdrug_hit_all_repo_disease_gene\tnot_hit_repo_gene\n";
#-------------------------------------------------------------------------------


 my @hit_counts; #对每个repo disease 而言，hit repo gene的count
 my @hit_count_repos; #hit repo diseases 的count
 my @one_drug_hit_all_repo_disease_gene; #一个drug hit 住所有的repo disease；
foreach my $drug (sort keys %hash1){
    if(exists $hash2{$drug}){
        my $fo1 ="./parameter_optimization/top/start/${drug}.txt"; 
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
        system "python run_walker.py original_network_num.txt parameter_optimization/top/start/${drug}.txt > parameter_optimization/top/rwr_result/${drug}.txt ";
        system "cat parameter_optimization/top/rwr_result/${drug}.txt | sort -k2,2rg >parameter_optimization/top/rwr_result/${drug}_sorted.txt";
        foreach my $cutoff(@top_cutoff){
            my$line = 12277*$cutoff;
            my $line2  = sprintf "%.f", $line; # 这个是四舍五入取整
            # print STDERR "$line2\n";
            system "head -$line2 parameter_optimization/top/rwr_result/${drug}_sorted.txt > parameter_optimization/top/rwr_result/${drug}_sorted_${cutoff}.txt ";
            
            # #-------------------------------------------------------------------------------
            my $f2 ="./parameter_optimization/top/rwr_result/${drug}_sorted_${cutoff}.txt";  
            open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";

        # foreach my $cutoff(@top_cutoff){
            #   my $fo2 ="./parameter_optimization/hit_result/result.txt"; #最终输出结果文件
            #   open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
            while(<$I2>){
                chomp;
                my @f = split/\t/;
                my $ID =$f[0];
                my $top = $f[1];
                # if($top >=$cutoff){
                        $hash6{$ID}=$top; 
                # }
            }
            #--------------------------------------------
            my $all_repo_count = @repos ;#所有的已知的repo 的计数
            foreach my $repo(@repos){
                # print STDERR "$drug\t$repo\n";
                        # print STDERR "$repo\t$top\t####\n";
                if(exists$hash3{$repo}){
                    my @genes= @{$hash3{$repo}};
                    my %hash10;
                    @genes = grep { ++$hash10{$_} < 2 } @genes;  #对数组内元素去重
                    my $genecount = @genes;# 所有的repo gene的count;
                    foreach my $ID (sort keys %hash6){
                        my $top = $hash6{$ID};
                       
                            foreach my $gene(@genes){
                                # print STDERR "$drug\t$repo\n";
                                if ($ID == $gene){
                                    #  print STDERR "$drug\t$repo\n";
                                    push @hit_counts,$ID;
                                    #----------------------------------------
                                    my %hash11;
                                     unless(exists $hash11{$ID}){  #把所有hit到的drug repo gene 去重push 到数组
                                        push @one_drug_hit_all_repo_disease_gene,$ID;
                                        $hash11{$ID}=1;
                                    }
                                    #---------------------------------------------------
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
             #-------------------------------------------------------
             my @all_repo_gene = @{$hash12{$drug}}; #drug 所对应的所有的repo disease gene
             my %hash13;
             @all_repo_gene = grep { ++$hash13{$_} < 2 } @all_repo_gene;
             my $all_repo_genes = @all_repo_gene;
             my $drug_hit_all_repo_disease_gene =  @one_drug_hit_all_repo_disease_gene;  #一个drug hit 住的所有repo gene
             my $not_hit_repo_gene  = $all_repo_genes - $drug_hit_all_repo_disease_gene;
             print $O5 "$cutoff\t$drug\t$all_repo_genes\t$drug_hit_all_repo_disease_gene\t$not_hit_repo_gene\n";
             @one_drug_hit_all_repo_disease_gene = ();
            my $a = @one_drug_hit_all_repo_disease_gene;
            # print STDERR "$cutoff\t$a\n";





        }
        
    }
}




 