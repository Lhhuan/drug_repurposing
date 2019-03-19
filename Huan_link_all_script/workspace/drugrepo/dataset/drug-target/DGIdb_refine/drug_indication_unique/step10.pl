#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step8_target_drug_indication.txt";
my $fo1 = "./step10_all_target_drug_indication_MOA.txt";# target_drug_indication的全部信息。
my $fo2 = "./step10_all_target_drug_indication_no_MOA.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tDrug_stage\tGene_name\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tInteraction_types\tDrug_claim_name\tDrug_claim_primary_name";
select $O1;
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\n";
select $O2;
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)  #drug_target的文件。
{
   chomp;
   unless(/^Drug_chembl_id|Drug_claim_primary_name/){
       my @f = split/\t/;
       my $Indication_class = $f[14];
       my $Drug_indication = $f[15];
       my $drug_moa = $f[7];
       if ($f[7] !~ /\bna|NULL|NONE\b/i){
           if ($f[15] !~/\bunknown|NA\b/i){
           print $O1 "$_\t$f[15]\n";
           }
           else{
           print $O1 "$_\t$f[14]\n";
           }
       }
       else{
           print $O2 "$_\n";
       }
       
   }
}


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";
