#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step4_interactions_v3_drug_target_indication_database.txt";
my $f2 = "./step5_all_drug_indication.txt";
my $fo1 = "./step6_target_drug_indication.txt"; # target_drug_indication的全部信息。
my $fo2 = "./step6_no_indication_drug.txt"; #没有indication的drug。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tDrug_stage\tGene_name\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tInteraction_types\tDrug_claim_name\tDrug_claim_primary_name";
select $O1;
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\n";
select $O2;
print "$header\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)  #drug_target的文件。
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
       my @f = split/\t/;
       my $drug_chembl_id_drug_claim_name = $f[1];
       push @{$hash1{$drug_chembl_id_drug_claim_name}},$_;
   }
}

while(<$I2>)  #drug_indication的文件。
{
   chomp;
   unless(/drug_chembl_id|drug_claim_name/){
       my @f = split/\t/;
       my $drug_chembl_id_drug_claim_name = $f[0];
       my $t = join"\t",@f[1..4]; 
       push @{$hash2{$drug_chembl_id_drug_claim_name}},$t;
   }
}

 foreach my $drug_chembl_id(sort keys %hash1){
       if(exists $hash2{$drug_chembl_id}){ 
            my @t= @{$hash1{$drug_chembl_id}};
            my @v2 = @{$hash2{$drug_chembl_id}};
             foreach my $t(@t){
                foreach my $v2(@v2){
                    my $k3 = "$t\t$v2";
                    unless(exists $hash3{$k3}){
                        print $O1 "$k3\n";
                        $hash3{$k3} = 1;
                    }   
                }
             }
        }
        
        else{                         #既没有匹配到chembl_id，也没有匹配到drug_claim_name。属于没有indication的药物。
            my @t = @{$hash1{$drug_chembl_id}};
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

