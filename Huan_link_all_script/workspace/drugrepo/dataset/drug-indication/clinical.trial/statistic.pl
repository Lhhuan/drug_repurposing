#!/usr/bin/perl

use warnings;
use strict;

my $fi_result ="./result_NCDid_title_phase_drug_disease_diseaseterm";

open my $fh_result, '<', $fi_result or die "$0 : failed to open input file '$fi_result' : $!\n";


while(<$fh_result>)
{
   chomp;
     my @f1 = split /\t/;
     
   if ($f1[2] =~/Phase 4/){
           my $drug = $f1[3];
           my $t = join "\t", @f1[4,5];
         #  print $drug."\t".$t."\t".$f1[2]."\n"
         print $t."\n"
         
         
  }
}     





