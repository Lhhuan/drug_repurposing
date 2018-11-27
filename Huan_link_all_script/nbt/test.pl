#!/usr/bin/perl

use warnings;
use strict;

my $fi_target_disease ="./step31_targetid_indication_drug_mimnumber_disorder_uniprotid";




open my $fh_target_disease, '<', $fi_target_disease or die "$0 : failed to open input file '$fi_target_disease' : $!\n";








while(<$fh_target_disease>)
{
   chomp;
    
        my @f1 = split /\t/;
         my $drug = $f1[2];
        my $target = $f1[0];
         
         print $drug."\t".$target."\n";
}
