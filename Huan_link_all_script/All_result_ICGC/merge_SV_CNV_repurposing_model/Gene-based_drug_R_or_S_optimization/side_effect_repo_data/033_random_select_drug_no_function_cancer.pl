##从032_random_drug_no_function_cancer.txt中选取200个，得033_random_select_drug_no_function_cancer.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./032_random_drug_no_function_cancer.txt";
my $fo1 = "./033_random_select_drug_no_function_cancer.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
my @array;
while(<$I1>)
{
    chomp;
    push @array,$_;
}


    for(my $i=1; $i<2001;$i++){# 给你 random 取1000 个看看 
        my @new = randomElem ( 1, @array ) ; # pick any $num from @array ，把$num和@array传递给子程序。这里是用的值传递。还有一种方式是引用传递，相当于硬链接
        print $O1 "$new[0]\n";
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
 


