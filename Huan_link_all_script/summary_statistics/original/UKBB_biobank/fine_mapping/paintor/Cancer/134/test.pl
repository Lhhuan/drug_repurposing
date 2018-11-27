#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
use Parallel::ForkManager; #多线程并行

#my $f1 ="/f/mulinlab/huan/summary_statistics/original/summary_cancer_revise.txt";
my $f1 ="./test.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";


# my ($a=0,$b=0,$c=0);
my $a= 0;
my $b= 0;
my $c =0;

while(<$I1>){

chomp;
my @array=split(/\s+/,$_);
    unless(/^name/){
        $a=$a + $array[1];
        $b=$b + $array[2];
        $c=$c + $array[3];
    }


}
print "A\t$a\nB\t$b\nC\t$c\n";