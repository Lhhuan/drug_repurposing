#从./output/05_filter_out_mtctscan_out_test_in_huan.txt 中选出2倍数目的./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt
#得./output/06_random_select_2_fold_negative.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;

my $f1 ="./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt";#
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./output/05_filter_out_mtctscan_out_test_in_huan.txt";#
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/06_random_select_2_fold_negative.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

while(<$I1>)
{
    chomp;
    if(/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$_\n";
    }
}

my $inject_command = "wc -l $f1";
my $line = readpipe($inject_command); #system 返回值
my @line_info = split/\s+/,$line;
my $line_number = $line_info[0];
$line_number = $line_number -1; #减去header 所占的行数
$line_number =$line_number * 2; #选出2倍数目的 $f1
print STDERR "$line_number\n";

my %hash1;
my %hash2;

my @text = <$I2>;#把文件读进数组
for(my $i=1; $i<11;$i++){# 给你 random 取11 个看看 
    my @new = randomElem ( $line_number, @text ) ; # pick any $num from @array ，把$num和@array传递给子程序。这里是用的值传递。还有一种方式是引用传递，相当于硬链接
    foreach my $v(@new){
        chomp($v);
        print $O1 "$v\n";
    }
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
