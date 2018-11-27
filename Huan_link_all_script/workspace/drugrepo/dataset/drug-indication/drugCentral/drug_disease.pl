#!/usr/bin/perl

use warnings;
use strict;

my $fi_indication ="./omop-relationship.txt";
my $fi_drug ="./active_ingredient.txt";


open my $fh_indication, '<', $fi_indication or die "$0 : failed to open input file '$fi_indication' : $!\n";
open my $fh_drug, '<', $fi_drug or die "$0 : failed to open input file '$fi_drug' : $!\n";


my %sii ;
my %sid ;

while(<$fh_indication>)
{
   chomp;
  if (/indication\s/){ 
        my @f1 = split /\t/;
         my $struct_id = $f1[1];
         my $concept_name = $f1[4];
         my $snomed_full_name = $f1[6];
         my $t = join "\t", @f1[4,6];
           push @{$sii{$struct_id}},$t;
      } 
}



while(<$fh_drug>)
{
   chomp;
     if (/^\d\S/){ 
        my @f2 = split /\t/;
     
         my $struct_id1 = $f2[8];
         my $active_moiety_unii = $f2[2];
         my $substance_name = $f2[6];
         my $d = join "\t", @f2[2,6];
         $sid{$struct_id1}= $d;
     } 
}



 foreach my $struct_id( sort keys %sii){
           if (exists $sid{$struct_id}){
              my @t = @{$sii{$struct_id}};
              foreach my  $t(@t){
                     print $struct_id ."\t". $sid{$struct_id}."\t".$t ."\n"
              }
            }
 }                                   
              

             
