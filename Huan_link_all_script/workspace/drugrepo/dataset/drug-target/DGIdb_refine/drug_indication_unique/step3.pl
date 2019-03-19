#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./step2-interactions_v3_drug_target_database.txt";
my $fo = "./step3-uni-drug.txt";   #在step1的基础上加了drug_chembl_id|drug_claim_primary_name这一列，用drug_chembl_id和drug_claim_primary_name这两个属性进行筛选。有drug_chembl_id的用drug_chembl_id，没有的用drug_claim_primary_name进行去重。
open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"drug_chembl_id|drug_claim_primary_name\n";
my (%hash1,%hash2,%hash3,%hash4);


while(<$I>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_primary_name/){
       my @f = split/\t/;
       my $drug_chembl_id_drug_claim_primary_name = $f[0];
       my $key4 = $drug_chembl_id_drug_claim_primary_name;
       unless(exists $hash4{$key4}){
           print "$key4\n";
           $hash4{$key4} = 1;  
       }
   }
}




close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

