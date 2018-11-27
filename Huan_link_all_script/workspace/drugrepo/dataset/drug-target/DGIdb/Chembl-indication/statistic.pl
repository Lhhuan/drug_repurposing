#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#把搜集到的drug-indication合在一个表里。


my $f4 ="./step4-result.txt";
my $f5 ="./step2-result.txt";
my $fo = "./statistic.txt";


open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"drug_chembl_id\tdrug_claim_name\tdrug_indication\tdatabase_source\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

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





close $I4 or warn "$0 : failed to close input file '$f4' : $!\n";
close $I5 or warn "$0 : failed to close input file '$f5' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

