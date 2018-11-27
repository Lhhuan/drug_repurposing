#!/usr/bin/perl

use warnings;
use strict;

my $fi_genes ="./genes.tsv";
my $fi_drug ="./phenotypes.tsv";

open my $fh_genes, '<', $fi_genes or die "$0 : failed to open input file '$fi_genes' : $!\n";
open my $fh_drug, '<', $fi_drug or die "$0 : failed to open input file '$fi_drug' : $!\n";

my %drug;
my %disease;


while(<$fh_drug>)
{
   chomp;
     if (/^PA\S/){ 
        my @f1 = split /\t/;
     
         my $id = $f1[0];
         
         $drug{$id}=1;       
     } 
}

while(<$fh_genes>)
{
   chomp;
     if (/^PA\S/){ 
        my @f2 = split /\t/;
     
         my $id1 = $f2[0];
         $disease{$id1}=1;         
     } 
}

foreach my $id( sort keys %drug){
          if (exists $disease{$id}){
              print $id."\n"
          }
}

