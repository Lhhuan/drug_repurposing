#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi_drug ="./interactions_v3-Chembl.txt";
my $fi_indication = "./chembl_indications-17_13-38-29.txt";
my $fo1 = "./step2-result.txt";
my $fo2 = "./step2_result_unmatch.txt";

open my $I1, '<', $fi_drug or die "$0 : failed to open input file '$fi_drug' : $!\n";
open my $I2, '<', $fi_indication or die "$0 : failed to open input file '$fi_indication' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

print $O1 "gene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_types\tdrug_claim_primary_name\tdrug_name\tdrug_chembl_id\tdrug_claim_name/chembl-drugID\tMOLECULE_NAME\tMOLECULE_NAME\tFIRST_APPROVAL\tMESH_ID\tMESH_HEADING\tEFO_ID\tEFO_NAME\tMAX_PHASE_FOR_IND\tUSAN_YEAR\tREFS\n";
print $O2 "gene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_type\tdrug_claim_primary_name\tdrug_name\tdrug_chembl_id\tdrug_claim_name\n";
my (%hash1,%hash2);
while(<$I1>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       for (my $i=0;$i<9;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
               unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
           }
           unless($f[5] eq "NONE"){
               my ($drug_claim_primary_name, $drug_name)= ($f[6], $f[7]);
               my $drug_id = $f[5];
               my $t = join"\t",@f[0..4,6..8];
               push @{$hash1{$drug_id}},$t;      
       }
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

 foreach my $drug_id(sort keys %hash1){
     if(exists $hash2{$drug_id}){ 
         my @t = @{$hash1{$drug_id}};
         my @k = @{$hash2{$drug_id}};
        foreach my $t(@t){
            foreach my $k(@k){
                print $O1 "$t\t$drug_id\t$k\n"
            }
        }
    }
    else{ 
        my @t = @{$hash1{$drug_id}}; 
        foreach my $t(@t){
            print $O2 "$t\t$drug_id\n"
        }
    }
      
 }



