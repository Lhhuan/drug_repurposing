#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1  ="./step1_out_drugbank_or_un-expri.txt"; 
my $fo1 = "./step2_chembl.txt";
my $fo2 = "./step2_no_chembl.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $header = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tDrug_stage\tGene_name\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tInteraction_types\tDrug_claim_name\tDrug_claim_primary_name";
select $O1;
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\n";

select $O2;
#print "Drug_chembl_id|Drug_claim_primary_name\tdrug_chembl_id|drug_claim_name\tdrug_stage\tdrug_interaction_source\n";
print "Drug_chembl_id|drug_claim_name\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/^Drug_chembl_id|Drug_claim_primary_name/){
        my @f = split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_chembl_id_Drug_claim_name = $f[1];
        my $drug_stage = $f[2];
        my $drug_interaction_source = $f[6];
        my $Interaction_types = $f[7];
        #my $key =join ("\t",@f[0,1,2,6]); 
        my $key = $Drug_chembl_id_Drug_claim_name;
        if ($Drug_chembl_id_Drug_claim_name =~ /CHEMBL/ ){
            unless(exists $hash2{$_}){
              print $O1 "$_\n";
              $hash2{$_} = 1;
          }
        }
      else{
          unless(exists $hash1{$key}){
                print $O2 "$key\n";
                $hash1{$key} = 1;
            }   
      }
   }
}


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";
