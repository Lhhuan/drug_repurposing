#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step8_target_drug_indication.txt"; #此文件包括有moa和没有moa的药物的indication
my $fo1 = "./step10-3_all_target_drug_indication.txt";  #没有indication的药物把
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tDrug_stage\tGene_name\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tInteraction_types\tDrug_claim_name\tDrug_claim_primary_name";
select $O1;
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)  
{
   chomp;
   unless(/^Drug_chembl_id|Drug_claim_primary_name/){
       my @f = split/\t/;
       my $Indication_class = $f[14];
       my $Drug_indication = $f[15];
       my $drug_moa = $f[7];
           if ($f[15] !~/\bunknown|NA\b/i){
           print $O1 "$_\t$f[15]\n"; #有indication的输出indication
           }
           else{
           print $O1 "$_\t$f[14]\n"; #没有indication的输出indication_class
           }
   }
}


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
