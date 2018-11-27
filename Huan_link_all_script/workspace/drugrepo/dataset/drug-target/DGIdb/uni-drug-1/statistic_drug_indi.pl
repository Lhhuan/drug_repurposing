#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./step4_all_drug_indication.txt";
my $fo1 = "./all1_statistic_uni_drug_indication.txt";
my $fo2 = "./all1_statistic_uni_drug.txt";
my $fo3 = "./all1_statistic_uni_indication.txt";


open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

select $O1;
print "drug_id\tindication_pair\n";
select$O2;
print "statistion\n";
select $O3;
print"statistic_indication\n";
my (%hash1,%hash2,%hash3);
while(<$I>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $drug_indication = $f[2];
       my $key1 = "$drug_chembl_id\t$drug_indication";
           unless(exists $hash1{$key1}){
               print $O1 "$key1\n";
               $hash1{$key1} = 1;
           }
          unless(exists $hash2{$drug_chembl_id}){
               print $O2 "$drug_chembl_id\n";
               $hash2{$drug_chembl_id} = 1;
          }
          unless(exists $hash3{$drug_indication}){
               print $O3 "$drug_indication\n";
               $hash3{$drug_indication} = 1;
          }
       }
   
}


close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";
close $O3 or warn "$0 : failed to close output file '$fo3' : $!\n";

