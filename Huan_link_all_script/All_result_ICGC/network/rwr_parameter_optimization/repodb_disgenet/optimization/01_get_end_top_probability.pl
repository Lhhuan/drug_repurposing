#得到../04_test_start_end_num_sorted.txt为start和end的pair
#对每个参数，每个start对应end result进行排序，取$top,得文件$sort_top_file， $top里的结果再与end取交集。所有重合的数据为param_top_probability/01_top_${top_p}_${parameter}_probability.txt
#然后查看param_top_probability/01_top_${top_p}_${parameter}_probability.txt的行数，输出到文件$final_parameter_result.txt里面。


#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $one = "50"; #循环开始的数值
my $int = "10";#循环间隔
my $one_end = "200";#循环结束的数值
my $top_p = 0.4;
my $test_interval = "${one}_${int}_${one_end}";
my @parts;
# my $i = 40;
my $i;
my $restart = 0.9;
my $one_end1= $one_end +1;
for ($i = $one;$i<$one_end1;$i=$i+$int){ #构造file part的数组，从50开始，以50为步长，一直增加到1000
    #$i= $i+10;
    push @parts,$i;  
}
foreach my $part1(@parts){
    foreach my $part2(@parts){
        my $parameter = "${part1}_${part2}_${restart}"; #每次参数及运行数据所在文件夹名字
        #my $top_p = 0.2;#取文件的top
        my $top = int($top_p*12277);  #取整数；
        $top = $top +1; #因文件第一行为header，所以加1

        my $f1 ="../04_test_start_end_num_sorted.txt";  #输入的是start和end的pair
        my $fo1 ="./param_top_probability/01_top_${top_p}_${parameter}_probability.txt"; 
        open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
        open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

        select $O1;
        print "start\tend\tprobability\n"; 

        my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

        while(<$I1>)
        {
            chomp;
            my @f= split /\t/;
            my $start = $f[0];
            my $end = $f[1];
            push @{$hash1{$start}},$end;
        }


        foreach my $start (sort keys %hash1){
            my @ends =@{$hash1{$start}};
            my @files = glob "./Parameter_data/$parameter/*$start*${restart}.txt"; #glob的返回结果必须是一个数组，即使只返回一个元素。 #把每个start所对应的end找出来。  #@file是包含路径的，是./$parameter下的文件
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
                foreach my $end(@ends){
                    if ($end_rwr == $end){
                        print $O1 "$start\t$end\t$probability\n";
                    }
                }
            }
        }

        close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";

        system "wc -l $fo1 >> ./final_parameter_result_${test_interval}_${top_p}.txt";  #最后这个要-1，因为这里包括header
        #print STDERR "$fo1\n";

    }
}
system "cat final_parameter_result_${test_interval}_${top_p}.txt | sort -k1,1nr >final_parameter_result_${test_interval}_${top_p}_sorted.txt";  #最后这个要-1，因为这里包括header



#system "cat 01_${parameter}_probability.txt | sort -k3,3gr >01_${parameter}_probability_sorted.txt" ;  #按通用数值排序，支持科学计数法
#system "cat 01_${parameter}_probability.txt | sort -t $'\t' -k3,3n >01_${parameter}_probability_sorted.txt" ;