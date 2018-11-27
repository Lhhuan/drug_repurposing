#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1  ="./step1_in_drugbank-expri.txt"; 
my $f2  ="./step1_in_drugbank-un-expri.txt"; 
my $f3  ="./step2_no_chembl.txt"; 
my $f4  ="./final_unique_no_indication.txt";
#my $f1  ="./step2_chembl.txt"; 
my $fo1 = "./step4_repeat.txt";
my $fo2 = "./step4_no_phase0.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
select $O1;
print "Drug_chembl_id|drug_claim_name\tsource\n";
select $O2;
print "Drug_chembl_id|drug_claim_name\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/^Drug_chembl_id/){
        my @f = split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_chembl_id_Drug_claim_name = $f[1]; 
        my $key1 = $Drug_chembl_id_Drug_claim_name;
        $hash1{$key1}=1;
   }
}

while(<$I2>)
{
   chomp;
   unless(/^Drug_chembl_id/){
        my @f = split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_chembl_id_Drug_claim_name = $f[1]; 
        my $key2 = $Drug_chembl_id_Drug_claim_name;
        $hash2{$key2}=1;
   }
}

while(<$I3>)
{
   chomp;
   unless(/^Drug_chembl_id/){
        my @f = split/\t/;
        my $Drug_chembl_id_Drug_claim_name = $f[0]; 
        my $key3 = $Drug_chembl_id_Drug_claim_name;
        $hash3{$key3}=1;
   }
}

while(<$I4>)
{
   chomp;
        my @f = split/\t/;
        my $Drug_chembl_id_Drug_claim_name = $f[0]; 
        my $key4 = $Drug_chembl_id_Drug_claim_name;
        $hash4{$key4}=1;

}

foreach my $key (sort keys %hash4){
    if (exists $hash1{$key}){
        print $O1 "$key\tdrugbank_exper\n";
    }
    elsif(exists $hash2{$key}){
        print $O1 "$key\tdrugbank_un_exper\n";
    }
    else{
        print $O2 "$key\n";
    }
}



