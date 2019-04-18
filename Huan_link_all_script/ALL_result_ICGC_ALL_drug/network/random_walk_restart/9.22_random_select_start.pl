#把按照./output/9.21_drug_num.txt的数据个数随机选择选择start个数1000次，文件在random_select文件夹下

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;

my $f1 ="./output/9.21_drug_num.txt";#输入的是drug target 数目
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";


my %hash1;
my %hash2;

while(<$I1>)
{
    chomp;
    my $num = $_;
    my $dir = "./output/huan_data_rwr/random_select/start/${num}";
    mkdir $dir unless -d $dir; #建文件夹
    my @array = ( 1..12277 );
    for(my $i=1; $i<1001;$i++){# 给你 random 取1000 个看看 
        my @new = randomElem ( $num, @array ) ; # pick any $num from @array ，把$num和@array传递给子程序。这里是用的值传递。还有一种方式是引用传递，相当于硬链接
        my $out = join ("\n",@new);
        my $fo1 ="${dir}/start${i}.txt"; 
        open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
        print $O1 "$out\n";
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
 


