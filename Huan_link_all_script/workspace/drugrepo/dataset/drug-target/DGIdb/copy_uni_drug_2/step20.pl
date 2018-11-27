#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi1 ="./step19_drug_no_indication_mannal.txt";
my $fi2 ="./step19_drug_no_indication_mannal-1.txt";
my $fi3 ="./step19_drug_no_indication-mannal-3.txt";
my $fo1 = "./step20_drug-indication-exist.txt"; #在适应症的药物    筛选出手动找的这些药物。

open my $I1, '<', $fi1 or die "$0 : failed to open input file '$fi1' : $!\n";
open my $I2, '<', $fi2 or die "$0 : failed to open input file '$fi2' : $!\n";
open my $I3, '<', $fi3 or die "$0 : failed to open input file '$fi3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print"drug_chembl_id\tdrug_stage\tinteraction_type\tinteraction_claim_source\tmax_phase\tfirst_approval\tindication_class\tdrug_claim_primary_name\tclinical_drug_name\tdrug_indication\tphase\tlink_or_reference\n";
while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       for (my $i=0;$i<12;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
           unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
       }
       unless($f[9] =~/NULL|NONE|NA/){
           my($drug_chembl_id, $drug_stage, $interaction_type, $interaction_claim_source, $max_phase, $first_approval, $indication_class, $drug_claim_primary_name, $clinical_drug_name, $drug_indication, $phase, $link) = ($f[0], $f[1], $f[2], $f[3], $f[4], $f[5], $f[6], $f[7], $f[8], $f[9], $f[10],$f[11]);
           my $v1 = join"\t",@f[0..11]; 
           print "$v1\n";
          
       }  
   }
}

while(<$I2>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my($drug_chembl_id, $drug_stage, $interaction_type, $interaction_claim_source, $max_phase, $first_approval, $indication_class, $drug_claim_primary_name, $clinical_drug_name, $MESH_heading, $MESH_ID, $EFO_ID, $EFO_NAME, $phase, $reference) = ($f[0], $f[1], $f[2], $f[3], $f[4], $f[5], $f[6], $f[7], $f[8], $f[9], $f[10],$f[11], $f[12], $f[13], $f[14]);
       my $drug_indication = "$MESH_ID||$MESH_heading||$EFO_ID||$EFO_NAME";   #将$MESH_ID||$MESH_heading||$EFO_ID||$EFO_NAME等在一起输出，都表示为drug_indication
       my $v2 = join"\t",@f[0..8]; 
       my $v3 = "$v2\t$drug_indication\t$phase\t$reference";
       print "$v3\n";
   }
}


while(<$I3>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       for (my $i=0;$i<14;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
           unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
       }
       if($f[1] =~/NULL/){
           unless($f[10] eq "NULL"){
               my($drug_chembl_id, $drug_other_chembl_id, $drug_stage, $interaction_type, $interaction_claim_source, $max_phase, $first_approval, $indication_class, $drug_claim_primary_name, $clinical_drug_name, $drug_indication, $link) = ($f[0], $f[1], $f[2], $f[3], $f[4], $f[5], $f[6], $f[7], $f[8], $f[9], $f[10],$f[11]);
               my $v3 = join"\t",@f[0,2..9]; #用于有indication的输出；
               my $phase = "NA";
               my $t = "$v3\t$drug_indication\t$phase\t$link";
               print "$t\n";
               #print "$_\n";
           }
       }
   }
}


