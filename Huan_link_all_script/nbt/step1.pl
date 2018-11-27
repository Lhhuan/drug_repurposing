#!/usr/bin/perl

use warnings;
use strict;

my $fi_uniprot ="./TTD_uniprot_success.txt";
my $fi_wg ="./wgEncodeGencodeUniProtV24lift37.txt";
my $fi_ttd ="./TTD_download.txt";


open my $fh_uniprot, '<', $fi_uniprot or die "$0 : failed to open input file '$fi_uniprot' : $!\n";
open my $fh_wg, '<', $fi_wg or die "$0 : failed to open input file '$fi_wg' : $!\n";
open my $fh_ttd, '<', $fi_ttd or die "$0 : failed to open input file '$fi_ttd' : $!\n";

 my %u2t;
 my %uid;
 my %t2d;

 while(<$fh_uniprot>)
  {
      chomp;
      if (/^TTD\S/){
          my @f1 = split /\t/;
          my $UniprotID1 = $f1[3];
          my $TTDTargetID1 = $f1[0];
          push @{$u2t{$UniprotID1}},$TTDTargetID1;
      }
  }

  while(<$fh_wg>)
  {
       chomp;
        my @f2 = split /\t/;
        my $UniprotID2 = $f2[1];
        $uid {$UniprotID2} =1;
  }
      
  while (<$fh_ttd>)
      {
        chomp;
         if (/Drug\(s\)/){
             my @f3 = split /\t/;
             my $TTDTargetID3 = $f3[0];
             my $Drugs = $f3[2];
             push @{$t2d{$TTDTargetID3}},$Drugs;

         }

      }
      foreach my $UniprotID( sort keys %u2t){
          if (exists $uid{$UniprotID}){
              my @TTDTargetID = @{$u2t{$UniprotID}};
             foreach my $tid (@TTDTargetID){
                  if (exists $t2d{$tid}){
                      my @Drugs = @{$t2d{$tid}};
                      foreach my $drug (@Drugs){
                         # print $drug."\t".$tid."\n";
                           print $drug."\t".$UniprotID."\t".$tid."\n"
                      #  print $tid."\n";
                   }
                  }
              }
          }
      }
       
                      