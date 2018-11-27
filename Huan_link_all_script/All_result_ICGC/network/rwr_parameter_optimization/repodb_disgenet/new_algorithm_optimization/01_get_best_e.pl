#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
use Parallel::ForkManager; #多线程并行

# my $pm = Parallel::ForkManager->new(30); ## 设置最大的线程数目

 my $f1 ="../04_test_start_end_num_sorted.txt";  #输入的是start和end的pair
#  my $f1 ="./123.txt";  #输入的是start和end的pair
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
 chomp;
 my @f= split /\t/;
 my $start = $f[0];
 my $end = $f[1];
 my $fo1 ="./test_start/$start.txt"; 
 open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
 select $O1;
 print $O1 "$start\n";
 close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
 push @{$hash1{$start}},$end;
 
}
my @es;
for (my$i = 0.5;$i<0.9;$i=$i+0.1){ #构造参数e的数组，从0.5开始，以0.1为步长，一直增加到0.9
    #$i= $i+10;
    push @es,$i;  
}

foreach my $e_p(@es){
    # my $e_p = 0.7;
    my $fo2 ="./start_end_pro/result_restart${e_p}.txt"; 
    open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";#overlap结果的的输出文件
    foreach my $start (sort keys %hash1){
        my @ends =@{$hash1{$start}};
        # my $pid = $pm->start and next; #开始多线程
            $ENV{'epp'} = $e_p ;#声明环境变量，方便下面传给python脚本
                    system "python run_walker.py /f/mulinlab/huan/All_result/network/original_network_num.txt test_start/$start.txt >teat_result/${start}_${e_p}result.txt -e $e_p"; #把rwr的结果定向到文件中
            my $f2 ="teat_result/${start}_${e_p}result.txt"; 
            open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";

            # my $fo2 ="./start_end_pro/result_restart${e_p}.txt"; 
            # open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";#overlap结果的的输出文件
            while(<$I2>)
            {
            chomp;
            my @f= split /\t/;
            my $end_re = $f[0];
            my $probilaty = $f[1];
            my @ends =@{$hash1{$start}};
                foreach my $end(@ends){
                    if ($end==$end_re){
                        print $O2 "$start\t$end\t$probilaty\n";
                    }
                }
            }
        # $pm->finish;  #多线程结束
    }
    close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n"; #关闭文件句柄
    system "cat start_end_pro/result_restart${e_p}.txt | sort -k3,3gr >start_end_pro/result_restart_${e_p}_sorted.txt";
}
# system "python run_walker.py testdata/test_network.ppi testdata/test_seed.txt";
# $ENV{'input_file'}  = $Normalized_sort_file; #设置环境变量
#         $ENV{'input_path'} = $PMID ;

# system "python run_walker.py /f/mulinlab/huan/All_result/network/original_network_num.txt test_start/$start.txt";