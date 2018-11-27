#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#将为没有target的药物在dgidb中寻找target。

my $f1 = "./01_out_huan_exist_dgidb.txt";
my $f2 = "./01_no_exist_dgidb.txt";
my $fo1 = "./02_out_huan_exist_dgidb_no_indication.txt"; #没有indication的01_out_huan_exist_dgidb.txt
my $fo2 = "./02_out_huan_exist_dgidb_indication_no_target.txt"; #有indication，没有target的01_out_huan_exist_dgidb.txt
my $fo3 = "./02_out_huan_exist_dgidb_indication_target.txt";#有indication、有target的01_out_huan_exist_dgidb.txt
my $fo4 = "./02_no_exist_dgidb_no_indication.txt";#没有indication的01_no_exist_dgidb.txt
my $fo5 = "./02_no_exist_dgidb_indication_no_target.txt"; #有indication，没有target的01_no_exist_dgidb.txt
my $fo6 = "./02_no_exist_dgidb_indication_target.txt";#有indication、有target的01_no_exist_dgidb.txt
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
open my $O5, '>', $fo5 or die "$0 : failed to open output file '$fo5' : $!\n";
open my $O6, '>', $fo6 or die "$0 : failed to open output file '$fo6' : $!\n";

my $header = "drug_name\tmoa\ttarget\tdisease_area\tindication\tphase\n";
select $O1;
print $header;
select $O2;
print $header;
select $O3;
print $header;
select $O4;
print $header;
select $O5;
print $header;
select $O6;
print $header;
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
   chomp;
   unless(/^drug_name/){
       my @f = split/\t/;
       my $indication = $f[4];
       my $target = $f[2];
       if ($indication=~/NULL|NONE/){
           print $O1 "$_\n";
       }
       elsif($target=~/NULL|NONE/){
           print $O2 "$_\n";
       }
       else{
           print $O3 "$_\n";
       }
     
   }
}

while(<$I2>)
{
   chomp;
   unless(/^drug_name/){
       my @f = split/\t/;
       my $indication = $f[4];
       my $target = $f[2];
       if ($indication=~/NULL|NONE/){
           print $O4 "$_\n";
       }
       elsif($target=~/NULL|NONE/){
           print $O5 "$_\n";
       }
       else{
           print $O6 "$_\n";
       }
     
   }
}

