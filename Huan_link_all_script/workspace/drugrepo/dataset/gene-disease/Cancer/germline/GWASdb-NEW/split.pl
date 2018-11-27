#!/usr/bin/perl
use warnings;
use strict;


my $fi_veps ="./all_snp_5E-1-vep";
open my $fh_veps, '<', $fi_veps or die "$0 : failed to open input file '$fi_veps' : $!\n";
 while(<$fh_veps>){
     unless(/^POS/){
             chomp;  
             my @f2 = split /\t/;
             my $POS = $f2[0];
             my $rsID = $f2[1];
             my $ref = $f2[2];
             my $alt = $f2[3];
             my $Region = $f2[4];
             my $symbol = $f2[5];
             my $ENSGid = $f2[6];
             my $type = $f2[7];
             my @information = split /&/,$Region;
             foreach my $region(@information){
                 print $POS."\t".$rsID."\t".$ref."\t".$alt."\t".$region."\t".$symbol."\t".$ENSGid."\t".$type."\n"
          }
     } 
 }
