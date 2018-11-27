#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#把搜集到的drug-indication合在一个表里。

my $f1 ="./TTD-drug_indication.txt";
my $f2 ="./GuideToPharmacology-drug_indication.txt";
my $f3 ="./Drugbank_drug_indication.txt";
my $f4 ="./chembl2-drug_indication.txt";
my $f5 ="./chembl1-drug_indication.txt";
my $f6 ="./TdgClinicalTrial-drug_indication.txt";
my $f7 ="./TEND_drug_indication.txt";
my $fo = "./step4_all_drug_indication.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $I6, '<', $f6 or die "$0 : failed to open input file '$f6' : $!\n";
open my $I7, '<', $f7 or die "$0 : failed to open input file '$f7' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"drug_chembl_id\tdrug_claim_name\tdrug_indication\tdatabase_source\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       my $interaction_claim_source = $f[3];
       my $drug_chembl_id = $f[7];
       my $drug_claim_name = $f[8];
       my $drug_indication = $f[10];
       my $key1 = "$drug_chembl_id\t$drug_claim_name\t$drug_indication\t$interaction_claim_source";
       unless(exists $hash1{$key1}){
               print "$key1\n";
               $hash1{$key1} = 1;
       }
   }
}

while(<$I2>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       my $interaction_claim_source = $f[3];
       my $drug_chembl_id = $f[7];
       my $drug_claim_name = $f[8];
       my $drug_indication = $f[9];
       my $key2 = "$drug_chembl_id\t$drug_claim_name\t$drug_indication\t$interaction_claim_source";
       unless(exists $hash2{$key2}){
               print "$key2\n";
               $hash2{$key2} = 1;
       }
   }
}

while(<$I3>)
{
   chomp;
   unless(/^ENSGID/){
       my @f = split/\t/;
       if ($f[9] !~ /NA/){ #不读入drugbank中没有indication的数据。
           my $drug_name = $f[3];
           my $drug_indication = $f[9];
           my $interaction_claim_source = $f[15];
           my $drug_chembl_id = $f[16];
           my $key3 = "$drug_chembl_id\t$drug_name\t$drug_indication\t$interaction_claim_source";
           unless(exists $hash3{$key3}){
               print "$key3\n";
               $hash3{$key3} = 1;
           }
       }
   }
}

while(<$I4>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       my $interaction_claim_source = $f[3];
       my $drug_chembl_id = $f[7];
       my $drug_claim_name = $f[8];
       my $MESH_ID = $f[9];
       my $MESH_heading = $f[10];
       my $EFO_ID = $f[11];
       my $EFO_NAME = $f[12];
       my $drug_indication = "$MESH_ID||$MESH_heading||$EFO_ID||$EFO_NAME";   #将$MESH_ID||$MESH_heading||$EFO_ID||$EFO_NAME等在一起输出，都表示为drug_indication
       my $key4 = "$drug_chembl_id\t$drug_claim_name\t$drug_indication\t$interaction_claim_source";
       unless(exists $hash4{$key4}){
           print "$key4\n";
           $hash4{$key4} = 1;
       }
   }
}

while(<$I5>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       my $interaction_claim_source = $f[3];
       my $drug_chembl_id = $f[7];
       my $drug_claim_name = $f[8];
       my $MESH_ID = $f[12];
       my $MESH_heading = $f[13];
       my $EFO_ID = $f[14];
       my $EFO_NAME = $f[15];
       my $drug_indication = "$MESH_ID||$MESH_heading||$EFO_ID||$EFO_NAME";
       my $key5 = "$drug_chembl_id\t$drug_claim_name\t$drug_indication\t$interaction_claim_source";
       unless(exists $hash5{$key5}){
           print "$key5\n";
           $hash5{$key5} = 1;
       }
   }
}

while(<$I6>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       my $interaction_claim_source = $f[3];
       my $drug_chembl_id = $f[7];
       my $drug_claim_name = $f[8];
       my $drug_indication = $f[9];
       my $key6 = "$drug_chembl_id\t$drug_claim_name\t$drug_indication\t$interaction_claim_source";
       unless(exists $hash6{$key6}){
           print "$key6\n";
           $hash6{$key6} = 1;
       }
   }
}

while(<$I7>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       my $interaction_claim_source = $f[3];
       my $drug_chembl_id = $f[7];
       my $drug_claim_name = $f[8];
       my $drug_indication = $f[9];
       my $key7 = "$drug_chembl_id\t$drug_claim_name\t$drug_indication\t$interaction_claim_source";
       unless(exists $hash7{$key7}){
           print "$key7\n";
           $hash7{$key7} = 1;
       }
   }
}

close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $I3 or warn "$0 : failed to close input file '$f3' : $!\n";
close $I4 or warn "$0 : failed to close input file '$f4' : $!\n";
close $I5 or warn "$0 : failed to close input file '$f5' : $!\n";
close $I6 or warn "$0 : failed to close input file '$f6' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

