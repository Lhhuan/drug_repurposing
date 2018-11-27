#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#将文件03_chembl_drug.txt中的一行中的多个indication进行分割
my $f1 ="./03_chembl_drug.txt";
my $fo1 = "./04_split_indication.txt";  #有chembl的文件
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "chembl_id\tdrug_name\tmoa\ttarget\tdisease_area\tindication\tphase\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/^chembl_id/){
       my @f = split/\t/;
       my $indication = $f[5];
       $indication =~ s/\"//g;
       my @g = split/\,/,$indication;
       foreach my $g(@g){
           $g =~ s/^\s//g;
           my $out = "$f[0]\t$f[1]\t$f[2]\t$f[3]\t$f[4]\t$g\t$f[6]";
           unless(exists $hash1{$out}){
               print $O1 "$out\n";
               $hash1{$out} = 1;
           }
       }
   }
}


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";