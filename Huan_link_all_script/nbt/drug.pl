#!/usr/bin/perl

use warnings;
use strict;

my $fi_uniprot ="./TTD_uniprot_success.txt";

my $fi_ttd ="./TTD_download.txt";


open my $fh_uniprot, '<', $fi_uniprot or die "$0 : failed to open input file '$fi_uniprot' : $!\n";

open my $fh_ttd, '<', $fi_ttd or die "$0 : failed to open input file '$fi_ttd' : $!\n";

 my %u2t;
 my %uid;
 my %t2d;

 while(<$fh_uniprot>)
  {
      chomp;
      if (/^TTD\S/){
          my @f1 = split /\t/;
       
          my $TTDTargetID1 = $f1[0];
           $u2t {$TTDTargetID1} =1;
      }
  }

  
      
  while (<$fh_ttd>)
      {
        chomp;
         if (/Drug\(s\)/){
             my @f3 = split /\t/;
             my $TTDTargetID3 = $f3[0];
             my $Drugs = $f3[2];
             print $Drugs ."\n";
             push @{$t2d{$TTDTargetID3}},$Drugs;

         }

      }
      foreach my $TTDTargetID1( sort keys %u2t){
          
                  if (exists $t2d{ $TTDTargetID1}){
                      my @Drugs = @{$t2d{ $TTDTargetID1}};
                      foreach my $drug (@Drugs){
                          print $drug."\n";
                        #   print $drug."\t".$UniprotID."\t".$tid."\n"
                      #  print $tid."\n";
                   }
                  }
              }
                        