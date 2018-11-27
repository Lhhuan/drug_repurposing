#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#将所有有indication和target的drug数据和在一个文件里。
my $f1 ="./02_no_exist_dgidb_indication_target.txt";
my $f2 = "./02_out_huan_exist_dgidb_indication_target.txt";
my $f3 = "./03_find_drug.txt";  
my $fo1 = "./06_drug_target_indication.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "drug_name\tmoa\ttarget\tdisease_area\tindication\tphase\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
   chomp;
   unless(/^drug_name/){
       my @f = split/\t/;
       my $drug_name = $f[0];
       print $O1 "$_\n";
   }
}

while(<$I2>)
{
   chomp;
   unless(/^drug_name/){
       my @f = split/\t/;
       my $drug_name = $f[0];
       print $O1 "$_\n";
   }
}

while(<$I3>)
{
   chomp;
   unless(/^gene/){
       my @f = split/\t/;
       my $drug_name = $f[1];
       unless ($f[0]=~/unknown/){
            my $v1 = join("\t", @f[1,2,0,4..6]);
            unless(exists $hash1{$v1}){
               print $O1 "$v1\n";
               $hash1{$v1} = 1;
            }
       }
      
   }
}
 

close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $I3 or warn "$0 : failed to close input file '$f3' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
