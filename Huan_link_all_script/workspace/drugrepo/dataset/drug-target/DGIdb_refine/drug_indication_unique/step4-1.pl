#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./step4_interactions_v3_drug_target_indication_database.txt";
my $fo = "./step4-1-uni-drug";   #用drug_chembl_id|drug_claim_name这列进行unique.
open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"drug_chembl_id|drug_claim_name\n";
my %hash1;

while(<$I>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_primary_name/){
       my @f = split/\t/;
       my $drug_chembl_id_drug_claim_primary_name = $f[1];
       my $key1 = $drug_chembl_id_drug_claim_primary_name;
       unless(exists $hash1{$key1}){
           print "$key1\n";
           $hash1{$key1} = 1;  
       }
   }
}

close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

