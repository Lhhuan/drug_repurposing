#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi_drug ="./interactions_v3-GuideToPharmacologyInteractions.txt";
my $fi_imm = "./immuno_disease2ligand.txt";
my $fi_disease = "./disease.txt";
my $fi_drug_indication = "./step2_result_drug_indication.txt";
my $fi_unmatch = "./step2_unmatch_drug.txt";
# my $fo3 = "./GuideToPharmacologyInteractions.txt";

open my $I1, '<', $fi_drug or die "$0 : failed to open input file '$fi_drug' : $!\n";
open my $I2, '<', $fi_imm or die "$0 : failed to open input file '$fi_imm' : $!\n";
open my $I3, '<', $fi_disease or die "$0 : failed to open input file '$fi_disease' : $!\n";
open my $O1, '>', $fi_drug_indication or die "$0 : failed to open output file '$fi_drug_indication' : $!\n";
open my $O2, '>', $fi_unmatch or die "$0 : failed to open output file '$fi_unmatch' : $!\n";
# open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
select $O1;
print "gene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_types\tdrug_claim_primary_name\tdrug_name\tdrug_chembl_id\tdrug_claim_name\tIndication\n";
select $O2;
print "drug_claim_name\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5);
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
               my $drug_claim_name = $f[5];
               my $t = join"\t",@f[0..4,6..8];
               push @{$hash1{$drug_claim_name}},$t;   
               #print $drug_claim_name."\n"
       }
   }
}



while(<$I2>)
{
   chomp;
   if(/^\d+/){
        my @f = split/\t/;
        my ($ligand_id, $disease_id) = ($f[1], $f[2]);
        push @{$hash2{$ligand_id}},$disease_id;
        }
}

while(<$I3>)
{
   chomp;
   if(/^\d+/){
        my @f = split/\t/;
        my ($disease_id, $name) = ($f[0], $f[1]);
        $hash3{$disease_id} = $name;
       # print "$name\n"
        }
}

foreach my $drug_claim_name(sort keys %hash1){
    if(exists $hash2{$drug_claim_name}){ 
        my @t = @{$hash1{$drug_claim_name}};
        my @disease_id = @{$hash2{$drug_claim_name}};
        foreach my $disease_id(@disease_id){
            foreach my$t(@t){
                if(exists $hash3{$disease_id}){ 
                    my $disease_name = $hash3{$disease_id};
                    my $key = "$t\t$drug_claim_name\t$disease_name";
                    unless(exists $hash4{$key}){
                        print  $O1 "$key\n";
                        $hash4{$key} = 1;
                    }
                }
            }  
        }
    }
    else{
        unless (exists $hash5{$drug_claim_name}){
        print $O2 "$drug_claim_name\n";
        $hash5{$drug_claim_name} = 1;
        }
    }
}





