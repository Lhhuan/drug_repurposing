#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./step8_no_indication_drug.txt";
my $fo = "./step9-unique-drug_no_indication.txt";   #用drug_chembl_id和drug_claim_primary_name这两个属性进行筛选。有drug_chembl_id的用drug_chembl_id，没有的用drug_claim_primary_name进行去重。
open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"drug_chembl_id|drug_claim_primary_name\n";
my %hash1;

while(<$I>)
{
   chomp;
   unless(/^Drug_chembl_id|Drug_claim_primary_name/){
       my @f = split/\t/;
       my $drug_chembl_id_drug_claim_name = $f[1];
       my $key1 = $drug_chembl_id_drug_claim_name;
    #    my $drug_chembl_id_drug_claim_name = $f[1];
    #    my $key1 =  $drug_chembl_id_drug_claim_name = $f[1];
       unless(exists $hash1{$key1}){
           print "$key1\n";
           $hash1{$key1} = 1;  
       }
   }
}

close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

