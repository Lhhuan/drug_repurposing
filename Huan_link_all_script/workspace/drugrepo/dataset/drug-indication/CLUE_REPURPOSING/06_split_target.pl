#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#将文件03_chembl_drug.txt中的一行多个target进行分割
my $f1 ="./03_chembl_drug.txt";
my $fo1 = "./06_split_target.txt";  #target split 后的文件
my $fo2 = "./06_uni_target.txt";  #unique target的文件
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "drug_name\ttarget\n";
select $O2;
print "target\n";


my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/^chembl_id/){
       my @f = split/\t/;
       my $target = $f[3];
       $target =~ s/\"//g;
       my @g = split/\,/,$target;
       foreach my $g(@g){
           $g =~ s/^\s//g;
           my $out = "$f[1]\t$g";
           unless(exists $hash1{$out}){
               print $O1 "$out\n";
               $hash1{$out} = 1;
           }
           unless(exists $hash2{$g}){
               print $O2 "$g\n";
               $hash2{$g} = 1;
           }
       }
   }
}


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";