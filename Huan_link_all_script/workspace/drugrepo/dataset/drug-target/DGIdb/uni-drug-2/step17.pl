#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi_drug ="./step16_drug_no_indication.txt";
my $fi_indication = "./chembl_indications-17_13-38-29.txt";
my $fo1 = "./step17_drug-indication-exist.txt"; #在CHEMBL中存在适应症的药物
my $fo2 = "./step17_drug_no_indication.txt"; #在CHEMBL中不存在适应症的药物

open my $I1, '<', $fi_drug or die "$0 : failed to open input file '$fi_drug' : $!\n";
open my $I2, '<', $fi_indication or die "$0 : failed to open input file '$fi_indication' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print"drug_chembl_id\tdrug_stage\tinteraction_type\tinteraction_claim_source\tmax_phase\tfirst_approval\tindication_class\tdrug_claim_primary_name\tMOLECULE_NAME\tMOLECULE_TYPE\tFIRST_APPROVAL\tMESH_ID\tMESH_HEADING\tEFO_ID\tEFO_NAME\tMAX_PHASE_FOR_IND\tUSAN_YEAR\tREFS\n";
select $O2;
print"drug_chembl_id\tdrug_stage\tinteraction_type\tinteraction_claim_source\tmax_phase\tfirst_approval\tindication_class\tdrug_claim_primary_name\n";
#open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my($drug_chembl_id, $drug_stage, $interaction_type, $interaction_claim_source, $max_phase, $first_approval, $indication_class, $drug_claim_primary_name) = ($f[0], $f[1], $f[2], $f[3], $f[4], $f[5], $f[6],$f[7]);
       my $key1 = join"\t",@f[1..7]; 
       $hash1{$drug_chembl_id} = $key1;
       
   }
}



while(<$I2>)
{
   chomp;
   unless(/^MOLECULE_CHEMBL_ID/){
        my @f = split/\t/;
        for (my $i=0;$i<11;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
               unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
           }
           #unless($f[5] eq "NONE"){
        my ($MOLECULE_CHEMBL_ID, $MOLECULE_NAME, $MOLECULE_TYPE, $FIRST_APPROVAL, $MESH_ID, $MESH_HEADING, $EFO_ID, $EFO_NAME, $MAX_PHASE_FOR_IND, $USAN_YEAR, $REFS) = ($f[0], $f[1], $f[2], $f[3], $f[4], $f[5], $f[6], $f[7], $f[8],$f[9],$f[10]);
        my $k = join"\t",@f[1..10];
        push @{$hash2{$MOLECULE_CHEMBL_ID}},$k;
       
        }
}

 foreach my $drug_chembl_id(sort keys %hash1){
     if(exists $hash2{$drug_chembl_id}){ 
         my $key1 = $hash1{$drug_chembl_id};
         my @k = @{$hash2{$drug_chembl_id}};
             foreach my $k(@k){
                 my $key3 = "$drug_chembl_id\t$key1\t$k";
                 unless(exists$hash3{$key3}){
                        print $O1 "$key3\n";
                        $hash3{$key3} = 1;
                   }
            }
    }
    else{ 
         my $key1 = $hash1{$drug_chembl_id};
         unless(exists$hash4{$key1}){
             print $O2 "$drug_chembl_id\t$key1\n";
             $hash4{$key1} = 1;
         }
    }
      
 }



