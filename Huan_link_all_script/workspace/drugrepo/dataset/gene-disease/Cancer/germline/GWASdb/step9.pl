#!/usr/bin/perl
use warnings;
use strict;


my $fi_step8_result ="./step8_result_in-gene_vep_disease_SNV";
open my $fh_step8_result, '<', $fi_step8_result or die "$0 : failed to open input file '$fi_step8_result' : $!\n";





while(<$fh_step8_result>)
{
    chomp;  
     my @f1 = split /\t/;
      unless (/^extend_POS/){
        if ($f1[16] < 5E-8){
            print $_."\n"
        }
        # else {
        #     print $_."\n"
        #     }
      }
}