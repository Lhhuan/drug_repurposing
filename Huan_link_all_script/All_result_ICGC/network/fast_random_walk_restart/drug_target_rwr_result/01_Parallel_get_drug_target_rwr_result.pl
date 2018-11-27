#得到../04_test_start_end_num_sorted.txt为start和end的pair
#对每个参数，每个start对应end result进行排序，取$top,得文件$sort_top_file， $top里的结果再与end取交集。所有重合的数据为param_top_probability/01_top_${top_p}_${parameter}_probability.txt
#然后查看param_top_probability/01_top_${top_p}_${parameter}_probability.txt的行数，输出到文件$final_parameter_result.txt里面。

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);#环境变量
use Parallel::ForkManager; #多线程并行


my @tops;
# # my $i = 40;
my $i;
my $top_p = 0.5;#取文件的top
        
my $top = int(${top_p}*12277); #取整数；#因文件第一行为header，所以加1
# my $f1 ="../start_drug_target_network_num_final.txt"; #输入的是start(drug_target)
my $f1 ="./test_start.txt"; #输入的是测试start(drug_target)
my $f3 ="../somatic_uni_entrez_num.txt"; #somatic gene，也就end
# my $fo1 = "drug-target_somatic-gene.txt";
my $fo1 = "test_result.txt";  #测试的result
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open input file '$fo1' : $!\n";
select $O1;
print "drug_target\tsomatic_gene\tprobability\n"; 

my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);



while(<$I1>)
{
    chomp;
    unless(/^start/){
    my @f= split /\t/;
    my $start = $f[0];
    $hash1{$start}=1;
    }
}
while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    my $end = $f[0];
    $hash2{$end}=1;
}

my $pm = Parallel::ForkManager->new(4); ## 设置最大的线程数目
foreach my $start (sort keys %hash1){
    my $pid = $pm->start and next; #开始多线程
    #print STDERR "$start\n";
    my @files = glob "./100_1000_0.9/r_${start}-100_1000_0.9.txt"; #glob的返回结果必须是一个数组，即使只返回一个元素。 #把每个start所对应的end找出来。  #@file是包含路径的，是./$parameter下的文件
    #print STDERR "@files\n";
    my $f_or ="$files[0]";
    my $sort_top_file = $f_or;
    $sort_top_file =~ s/.txt/sorted_top_${top_p}.txt/g;  #此文件里存放的是score top 0.2的节点
    system "cat $f_or | sort -k2,2gr|head -$top > $sort_top_file" ;  #先按照数字排序，然后取top，$sort_top_file是包含路径的，是./$parameter下的文件

    my $f2 ="$sort_top_file";  #$sort_top_file是包含路径的，是./Parameter_data/$parameter下的文件
    open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
    while(<$I2>){
    chomp;
    my @f= split /\t/;
    my $end_rwr = $f[0];
    my $probability = $f[1];
        foreach  my $end (sort keys %hash2){
            if ($end_rwr == $end){
                print $O1 "$start\t$end\t$probability\n";
            }
        }
    }
    $pm->finish;#多线程结束
} 
        close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";
#     }
# }
#system "cat final_parameter_result_${test_interval}_${top_p}.txt | sort -k1,1nr >final_parameter_result_${test_interval}_${top_p}_sorted.txt";   #最后这个要-1，因为这里包括header
# system "cat final_parameter_result_review.txt | sort -k1,1nr >final_parameter_result_review_sorted.txt";


#system "cat 01_${parameter}_probability.txt | sort -k3,3gr >01_${parameter}_probability_sorted.txt" ;  #按通用数值排序，支持科学计数法
#system "cat 01_${parameter}_probability.txt | sort -t $'\t' -k3,3n >01_${parameter}_probability_sorted.txt" ;