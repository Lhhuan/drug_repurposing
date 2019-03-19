#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi_indication = "./step3_result.txt";
my $fi_unmatch ="./step2_result_unmatch.txt";
my $fo1 = "./step4-result.txt";
my $fo2 = "./step4-unmatch-chembl.txt";

open my $I1, '<', $fi_indication or die "$0 : failed to open input file '$fi_indication' : $!\n";
open my $I2, '<', $fi_unmatch or die "$0 : failed to open input file '$fi_unmatch' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

print $O1 "gene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_type\tdrug_claim_primary_name\tdrug_name\tdrug_chembl_id\tdrug_claim_name\tMESH_ID\tMESH_HEADING\tEFO_ID\tEFO_NAME\tpref_name\tmolecule_type\n";

my %hash1;
my %hash2;

while(<$I1>)
{
   chomp;
   if(/^\d+/){
        my @f = split/\t/;
        my ($mesh_id, $mesh_heading, $efo_id, $efo_term, $pref_name, $chembl_id, $molecule_type) = ($f[3], $f[4], $f[5], $f[6], $f[8], $f[9], $f[11]);
        my $k = join"\t",@f[3..6, 8, 11];
        push @{$hash1{$chembl_id}},$k;
        }
}

while(<$I2>)
{
   chomp;
   unless(/^gene_name/){
        my @f = split/\t/;
        my $drug_id = $f[8];
        my $t = join"\t",@f[0..7];
        push @{$hash2{$drug_id}},$t;
        }
}

foreach my $drug_id(sort keys %hash2){
        if(exists $hash1{$drug_id}){ 
            my @k = @{$hash1{$drug_id}};
            my @t = @{$hash2{$drug_id}};
            foreach my $t(@t){
                foreach my $k(@k){
                   print $O1 "$t\t$drug_id\t$k\n";
                   # print "$chembl_id\n"
                }
           }     
       }
       else {
           print $O2 $drug_id."\n";
       }
  }