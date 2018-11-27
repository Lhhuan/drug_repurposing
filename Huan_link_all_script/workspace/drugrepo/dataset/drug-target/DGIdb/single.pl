#!/usr/bin/perl

use warnings;
use strict;

my $fi_drug_disease ="./merge_interactions.tsv";


open my $fh_drug_disease, '<', $fi_drug_disease or die "$0 : failed to open input file '$fi_drug_disease' : $!\n";



while(<$fh_drug_disease>)
{
   chomp;
   if ($_ !~/^$/){
     
       print $_."\n"           
     
   }

}
