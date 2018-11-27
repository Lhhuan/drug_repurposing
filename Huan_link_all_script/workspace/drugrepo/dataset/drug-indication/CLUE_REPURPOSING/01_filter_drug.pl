#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#将文件中没有target和indication的数据筛掉。

my $fi ="./Repurposing_Hub_export.txt";
my $fo = "./01_filter_repurposing_hub.txt";

open my $I1, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print "drug_name\tmoa\ttarget\tdisease_area\tindication\tphase\n";
while(<$I1>)
{
   chomp;
   unless(/^Name/){
       my @f = split/\t/;
       for (my $i=0;$i<9;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
               unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
           }
        unless($f[2] =~/NONE|NULL/){  #将文件中没有target的数据筛掉。
            unless($f[4] =~ /NONE|NULL/){ #将文件中没有indication的数据筛掉。
                my($drug_name,$moa,$target,$disease_area,$indication,$phase) = ($f[0],$f[1],$f[2],$f[3],$f[4],$f[8]);
                print "$f[0]\t$f[1]\t$f[2]\t$f[3]\t$f[4]\t$f[8]\n";
            }
       }
   }
}



