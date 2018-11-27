#!/usr/bin/perl

use warnings;
use strict;

my $fi_studies ="./studies1";
my $fi_interventions ="./intervention1";
my $fi_condition ="./conditions.txt";
my $fi_condition_mesh ="./browse_conditions.txt";

open my $fh_studies, '<', $fi_studies or die "$0 : failed to open input file '$fi_studies' : $!\n";
open my $fh_interventions, '<', $fi_interventions or die "$0 : failed to open input file '$fi_interventions' : $!\n";
open my $fh_condition, '<', $fi_condition or die "$0 : failed to open input file '$fi_condition' : $!\n";
open my $fh_condition_mesh, '<', $fi_condition_mesh or die "$0 : failed to open input file '$fi_condition_mesh' : $!\n";

my %ntp;
my %ndr;
my %nid;
my %nim;

while(<$fh_studies>)
{
   chomp;
     if (/^NCT0\S/){ 
        my @f1 = split /\|/;
     
         my $NCD_ID1 = $f1[0];
         my $title = $f1[21];
         my $phase = $f1[25];
         my $t = join "\t", @f1[21,25];
         push @{$ntp{$NCD_ID1}},$t;
     } 
}


while (<$fh_interventions>)
{
        chomp;
      if (/Drug\|/){ 
             my @f2 = split /\|/;
              my $NCD_ID2 = $f2[1];
              my $Drug = $f2[3];
             push @{$ndr{$NCD_ID2}},$Drug; 
      } 
}


while(<$fh_condition>)
{
        chomp;
        if(/^[0-9]+\|/){
             my @f3 = split /\|/;
              my $NCD_ID3 = $f3[1];
              my $disease = $f3[2];
             push @{$nid{$NCD_ID3}},$disease; 
       }           
}

while(<$fh_condition_mesh>)
{
        chomp;
        if(/^[0-9]+\|/){
             my @f4 = split /\|/;
              my $NCD_ID4 = $f4[1];
              my $mesh_term = $f4[2];
             push @{$nim{$NCD_ID4}},$mesh_term; 
       } 
}


foreach my $NCD_ID2( sort keys %ndr){
          if (exists $ntp{$NCD_ID2}){
                if (exists $nid{$NCD_ID2}){
                      if (exists $nim{$NCD_ID2}){
                         my @t = @{$ntp{$NCD_ID2}};
                         my @Drug = @{$ndr{$NCD_ID2}};
                         my @disease = @{$nid{$NCD_ID2}};
                         my @mesh_term = @{$nim{$NCD_ID2}};
                         foreach my $title_phase (@t){
                               foreach my $drug (@Drug){
                                     foreach my $disease (@disease){
                                           foreach my $disease_mesh (@mesh_term){
                                                 print $NCD_ID2."\t".$title_phase."\t".$drug."\t".$disease."\t".$disease_mesh."\n"

                                           }
                                    }
                               }
                         }
                     }
             }
        }
}                                   
              

             
