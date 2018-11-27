#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step10_all_target_drug_indication_MOA.txt";
my $f2 = "./step10_all_target_drug_indication_no_MOA.txt";
my $fo1 = "./step10-1_target_drug_indication_moa_repetition.txt"; # drug_indication的信息在step10_all_target_drug_indication_MOA.txt重复，但是没有moa。
my $fo2 = "./step10-1_target_drug_indication_no-moa_unique.txt"; #没有moa的drug。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
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
       my $drug_chembl_id_drug_claim_name = $f[1];
       my $k = $_;
       push @{$hash1{$drug_chembl_id_drug_claim_name}},$k;
   }
}

while(<$I2>)  
{
   chomp;
   unless(/Drug_chembl_id|Drug_claim_primary_name/){
       my @f = split/\t/;
       my $drug_chembl_id_drug_claim_name = $f[1];
       my $t = $_; 
       push @{$hash2{$drug_chembl_id_drug_claim_name}},$t;
   }
}

 foreach my $drug_chembl_id(sort keys %hash2){
       if(exists $hash1{$drug_chembl_id}){  #在两个文件中重复的药物
            my @v2 = @{$hash2{$drug_chembl_id}};
                foreach my $v2(@v2){
                    unless(exists $hash3{$v2}){
                        print $O1 "$v2\n";
                        $hash3{$v2} = 1;
                    }   
                }
        }
        else{  #得没有moa的unique的药物
            my @t = @{$hash2{$drug_chembl_id}};
            foreach my $t(@t){
                my $k4 = $t;
                unless(exists $hash4{$k4}){
                    print $O2 "$k4\n";
                    $hash4{$k4} = 1;
                }
            }
        }
 }

       
       
close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";

