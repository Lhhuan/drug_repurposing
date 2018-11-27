#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#在chembl_molecules.txt对文件step2-interactions_v3_drug_target_database.txt进行tmax_phase\tfirst_approval\tindication_class的信息补充。
# my $f1 ="./123.txt";
# my $f2 = "./456.txt";
my $f1 ="./01_filter_repurposing_hub.txt";
my $f2 = "./DGIdb_all_drug_target.txt";
my $fo1 = "./022_repeat.txt";  
my $fo2 = "./022_no_repeat_hub.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O2;
print "drug_name\tmoa\ttarget\tdisease_area\tindication\tphase\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
   chomp;
   unless(/^drug_name/){
       my @f = split/\t/;
       my $drug_name = $f[0];
       $drug_name=~s/\W//g;
       $drug_name=~ s/($drug_name)/\L$1/gi;
       my $key1 = $drug_name; 
       $hash1{$key1} = $_;
   }
}

while(<$I2>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_claim_primary_name = $f[8];
       my $key2 =$drug_claim_primary_name;
       $key2=~s/\W//g;
       $key2=~ s/($key2)/\L$1/gi;
       $hash2{$key2}=1;
   }
}

 foreach my $key1(sort keys %hash1){
       if(exists $hash2{$key1}){ 
           unless(exists $hash3{$key1}){
               print $O1 "$key1\n";
               $hash3{$key1} = 1;
           }
       }
       else{
           my $v1=$hash1{$key1};
           unless(exists $hash4{$v1}){
               print $O2 "$v1\n";
               $hash4{$v1} = 1;
               }
       }
 }

close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";