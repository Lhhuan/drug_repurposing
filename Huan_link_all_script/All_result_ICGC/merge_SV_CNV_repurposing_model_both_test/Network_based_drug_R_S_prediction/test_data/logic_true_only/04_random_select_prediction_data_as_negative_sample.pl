#随机选取../../huan_data/only_logic_true/output/031_calculate_for_network_based_repo_logistic_regression_data_final.txt 中的150个做作为负样本，得./output/04_random_select_prediction_data_as_negative.txt
#把./output/03_final_filter_repo_withdrwal_data_for_logistic_regression.txt和./output/04_random_select_prediction_data_as_negative.txt cat 到一起得./output/04_final_data_for_logistic_regression.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);

my $f1 ="../../huan_data/only_logic_true/output/031_calculate_for_network_based_repo_logistic_regression_data_final.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/04_random_select_prediction_data_as_negative.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;

my @array = <$I1>;#把文件读进数组
my $num = "394";
my @new = randomElem ( $num, @array ) ; # pick any $num from @array ，把$num和@array传递给子程序。这里是用的值传递。还有一种方式是引用传递，相当于硬链接
# my $out = join ("\n",@new);
foreach my $new_line (@new){
    chomp($new_line);
    my $output1 = "$new_line\trandom_select_negative_sample\t0";
    print $O1 "$output1\n";
}



sub randomElem { #随机取
    my ($want, @array) = @_ ;
    my (%seen, @ret);
     while ( @ret != $want ) {
     my $num = abs(int(rand(@array))); #@array 是指数组的长度，而$#array是指最后一个索引，由于rand的特殊性，如果用$#array会导致取不到最后一个值。
      if ( ! $seen{$num} ) { 
        ++$seen{$num};
        push @ret, $array[$num];
      }
     }
    return @ret;     
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

system "cat ./output/03_final_filter_repo_withdrwal_data_for_logistic_regression.txt ./output/04_random_select_prediction_data_as_negative.txt >./output/04_final_data_for_logistic_regression.txt";