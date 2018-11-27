#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step10-1_target_drug_indication_no-moa_unique.txt";
my $fo1 = "./step10-2_target_drug_indication_no-moa_unique_fda.txt"; # drug_indication的信息在step10_all_target_drug_indication_MOA.txt重复，但是没有moa。
my $fo2 = "./step10-2_target_drug_indication_no-moa_unique_nofda.txt"; #没有indication的drug。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tDrug_stage\tGene_name\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tInteraction_types\tDrug_claim_name\tDrug_claim_primary_name";
select $O1;
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\n";
select $O2;
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>) 
{
   chomp;
   unless(/^Drug_chembl_id|Drug_claim_primary_name/){
       my @f = split/\t/;
       my $first_approval = $f[13];
       if ($f[13] =~/\d+/){
           print $O1 "$_\n";
       }
       else{
           print $O2 "$_\n";
       }
   }
}

close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";

