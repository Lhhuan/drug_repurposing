#!/usr/bin/perl
use warnings;
use strict;


my $fi_gnomed_vep ="./index_snp_5E-1vep";
open my $fh_gnomed_vep, '<', $fi_gnomed_vep or die "$0 : failed to open input file '$fi_gnomed_vep' : $!\n";





while(<$fh_gnomed_vep>)
{
    chomp;  
    
      #if (/^("Use.*)(\d+)(\.")$/){
    if(/^"Use.*line\s([0-9]+)\."\s+$/){
        print "$1\n";

        
            

               
      }
}