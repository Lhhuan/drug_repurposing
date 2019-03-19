#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1  ="./all_no_indication_drug.txt"; 
my $fo1 = "./step1_in_drugbank-expri.txt";
#my $fo2 = "./step1_in_drugbank-un-expri.txt";
my $fo2 = "./step1_out_drugbank_or_un-expri.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
#open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
select $O1;
print "Drug_chembl_id|Drug_claim_primary_name\tdrug_chembl_id|drug_claim_name\tdrug_stage\tdrug_interaction_source\n";
# select $O2;
# print "Drug_chembl_id|Drug_claim_primary_name\tdrug_chembl_id|drug_claim_name\tdrug_stage\tdrug_interaction_source\n";

select $O2;
my $header = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tDrug_stage\tGene_name\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tInteraction_types\tDrug_claim_name\tDrug_claim_primary_name";
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\n";
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
        my $key =join ("\t",@f[0,1,2,6]); 
        if ($drug_interaction_source =~ /Drugbank/ ){
            if($drug_stage =~ /Experimental/){
                 unless(exists $hash1{$key}){
                    print $O1 "$key\n";
                    $hash1{$key} = 1;
            }
            }
            else{
                 unless(exists $hash2{$_}){
                    print $O2 "$_\n";
                    $hash2{$_} = 1;
                 }
            }
      }
      else{
          unless(exists $hash3{$_}){
              print $O2 "$_\n";
              $hash3{$_} = 1;
          }
      }
   }
}


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";
#close $O3 or warn "$0 : failed to close output file '$fo3' : $!\n";

