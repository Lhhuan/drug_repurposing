#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./step6_no_indication_drug.txt";
my $f2  ="./step6_target_drug_indication.txt";
my $fo1 = "./step8_target_drug_indication.txt"; # target_drug_indication的全部信息。
my $fo2 = "./step8_no_indication_drug.txt"; #没有indication的drug。
open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $I1, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tDrug_stage\tGene_name\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tInteraction_types\tDrug_claim_name\tDrug_claim_primary_name";
select $O1;
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\n";
select $O2;
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\n";
my %hash1;

while(<$I>)
{
   chomp;
   unless(/^Drug_chembl_id|Drug_claim_primary_name/){
       my @f = split/\t/;
       my $indication_class= $f[14];
       if($f[14] =~/\\N|unknown/){
           print $O2 "$_\n";
             
           }
       else{
           my $key1 =$_;
           unless(exists $hash1{$key1}){
               print $O1 "$key1\tunknown\tunknown\tunknown\tunknown\n";
               $hash1{$key1} = 1;
          }
       
      }
   }
}

while(<$I1>)
{
   chomp;
   unless(/^Drug_chembl_id|Drug_claim_primary_name/){
       print $O1 "$_\n";
   }
}

close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $I1 or warn "$0 : failed to close input file '$f2' : $!\n";
close $O1 or warn "$0 : failed to close input file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close input file '$fo2' : $!\n";



