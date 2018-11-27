#!/usr/bin/perl
use warnings;
use strict;


my $fi_veps ="./P1-01-TTD_download.txt";
open my $fh_veps, '<', $fi_veps or die "$0 : failed to open input file '$fi_veps' : $!\n";
 while(<$fh_veps>){
     unless(/^TTD/){
         if (/^T/){
             chomp;  
             my @f = split /\t/;
             print $f[1]."\n"
             #my $type = $f2[7];
            
          }
     } 
 }
