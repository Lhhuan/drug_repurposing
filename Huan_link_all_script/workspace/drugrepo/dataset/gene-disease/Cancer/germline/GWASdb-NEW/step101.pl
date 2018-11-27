#!/usr/bin/perl
use warnings;
use strict;

my $fi_snp_disease_vep ="step9-result-SNV-coding";
open my $fh_snp_disease_vep, '<', $fi_snp_disease_vep or die "$0 : failed to open input file '$fi_snp_disease_vep' : $!\n";

while(<$fh_snp_disease_vep>)
{
    chomp;
    my @f= split /\t/;
     unless(/^EXTEND/){
          my $P_value = $f[16];
          if ($P_value < 5E-8){
            #  print $_."\n"
          }
          else {print $_."\n"}
     }
}

