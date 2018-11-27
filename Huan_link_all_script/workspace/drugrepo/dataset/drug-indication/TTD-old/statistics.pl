#!/usr/bin/perl

use warnings;
use strict;

my $fi_drug_disease ="./Result_TTDdrugid_drugname_disease.txt";


open my $fh_drug_disease, '<', $fi_drug_disease or die "$0 : failed to open input file '$fi_drug_disease' : $!\n";


#my %ddr;
while(<$fh_drug_disease>)
{
   chomp;
     unless (/^TTDdrugID/){ 
        my @f1 = split /\t/;
     
         my $TTDdrug_id = $f1[0];
         my $drug_name = $f1[1];
         my $disease = $f1[2];
       #  print  $TTDdrug_id."\t".$drug_name."\t".$disease."\n"
         print  $drug_name."\n"
        # print  $disease."\n"
                  
     } 
}


