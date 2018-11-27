#!/usr/bin/perl
use warnings;
use strict;
my $fi_TTD_download ="P1-01-TTD_download.txt";
open my $fh_TTD_download, '<', $fi_TTD_download or die "$0 : failed to open input file '$fi_TTD_download' : $!\n";


while(<$fh_TTD_download>)
{
    chomp;
     unless(/^TTD/){
         if (/^T/){
             my @f1 = split /\t/;
          #   if ($f1[1] =~ /UniProt ID/){ 
              if ($f1[1] =~ /Synonyms/){
      print $_."\n"
             }
          }
     }
}