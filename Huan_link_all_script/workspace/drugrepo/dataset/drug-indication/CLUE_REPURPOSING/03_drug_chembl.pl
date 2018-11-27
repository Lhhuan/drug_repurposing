#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#为02_no_repeat_hub.txt 寻找chembl id
my $f1 ="./02_no_repeat_hub.txt";
my $f2 = "./chembl_drugs-18_13_48_30.txt";
my $fo1 = "./03_yes_chembl.txt";  #有chembl的文件
my $fo2 = "./03_no_chembl.txt";  #没有chembl_id 
my $fo3 = "./03_chembl_drug.txt";  #有或者没有chembl id 都输入进这一个文件。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
select $O1;
print "chembl\tdrugname\n";
select $O2;
print "drug_name\tmoa\ttarget\tdisease_area\tindication\tphase\n";
select $O3;
print "chembl_id\tdrug_name\tmoa\ttarget\tdisease_area\tindication\tphase\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/^drug_name/){
       my @f = split/\t/;
       my $drug_name1 = $f[0];
       my $key1 = $drug_name1; 
       $hash1{$key1} = $_;
   }
}

while(<$I2>)
{
   chomp;
   unless(/^PARENT_MOLREGNO/){
       my @f = split/\t/;
       my $chembl_id = $f[1];
       my $drug_name2 = $f[2];  
       my $key2 =$drug_name2;
       $key2=~s/\W//g;
       $key2=~ s/($key2)/\L$1/gi; 
       $hash2{$key2}=$chembl_id;
   }
}

 foreach my $key1(sort keys %hash1){
       if(exists $hash2{$key1}){ 
           my $chembl_id = $hash2{$key1};
           my $v1 = $hash1{$key1};
           my $q = "$chembl_id\t$v1";
           my $p = "$chembl_id\t$key1";  
           unless(exists $hash3{$p}){
               print $O1 "$p\n";
               $hash3{$p} = 1;
           }
           unless(exists $hash5{$p}){
               print $O3 "$q\n";
               $hash5{$q} = 1;
           }
       }
       else{
           my $v1=$hash1{$key1};
           unless(exists $hash4{$v1}){
               print $O2 "$v1\n";
               $hash4{$v1} = 1;
            }
            my $p = "NONE\t$v1";
            unless(exists $hash6{$p}){
               print $O3 "$p\n";
               $hash6{$p} = 1;
           }
       }
 }

close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";
close $O3 or warn "$0 : failed to close output file '$fo3' : $!\n";