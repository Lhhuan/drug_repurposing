#!/usr/bin/perl

use warnings;
use strict;

my $fi_drug_disease ="./drug-disease_TTD2013.txt";
open my $fh_drug_disease, '<', $fi_drug_disease or die "$0 : failed to open input file '$fi_drug_disease' : $!\n";
my $fo1 ="./Result_TTDdrugid_drugname_disease.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "TTDdrug_id\tdrug_name\tdisease\n";

my %hash1;
while(<$fh_drug_disease>)
{
   chomp;
     unless (/^TTDDRUGID/){
      my @f1 = split /\t/;
        for (my $i=0; $i<5; $i++){  #对文件进行处理，把所有未定义的空格等都替换成NONE
          unless(defined $f1[$i]){
            $f1[$i] = "NONE";
          }
        }
        unless($f1[2] eq "NONE"){
          my $TTDdrug_id = $f1[0];
          my $drug_name = $f1[1];
          my $disease = $f1[2];
          my $output = "$TTDdrug_id\t$drug_name\t$disease";
          unless(exists $hash1{$output}){
            $hash1{$output}=1;
            print $O1 "$output\n";
          }
        }
     }
}



