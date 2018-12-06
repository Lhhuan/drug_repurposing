#随机选择../huan_data/output/023_calculate_for_gene_based_repo_logistic_regression_data_final.txt中随机选取数据，作为测试集的负样本13_random_select_prediction_data_as_negative_sample.txt
#最后将11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt和13_random_select_prediction_data_as_negative_sample.txt cat 到一起得13_final_data_for_logistic_regression.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);

my $f1 ="../huan_data/output/023_calculate_for_gene_based_repo_logistic_regression_data_final.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./13_random_select_prediction_data_as_negative_sample.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;

my @array = <$I1>;#把文件读进数组
my $num = "30"; #随机选取的个数是num
my @new = randomElem ( $num, @array ) ; # pick any $num from @array ，把$num和@array传递给子程序。这里是用的值传递。还有一种方式是引用传递，相当于硬链接
# my $out = join ("\n",@new);
foreach my $new_line (@new){
    chomp($new_line);
    my $output1 = "$new_line\t0";
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

system "cat ./11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt ./13_random_select_prediction_data_as_negative_sample.txt >./13_final_data_for_logistic_regression.txt";