##把./random_select/rwr_result/${num}/result${i}_sorted.txt 里面的每个文件,取top4.4%， 把筛选结果放在./random_select/rwr_result_top_0.044/${num}/result${i}.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./021_target_num.txt";#输入的是drug target 数目
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";

while(<$I1>)
{
    chomp;
    my $num = $_;
    my $dir = "./random_select/rwr_result_top_0.044/${num}";
    mkdir $dir unless -d $dir; #建文件夹
    for(my $i=1; $i<1001;$i++){#
        my $line = 0.044*12277;
        my $line2  = sprintf "%.f", $line; # 这个是四舍五入取整
        system "head -n $line2 ./random_select/rwr_result/${num}/result${i}_sorted.txt > ./random_select/rwr_result_top_0.044/${num}/result${i}.txt";
    }
}
