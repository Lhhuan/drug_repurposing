#!/usr/bin/perl
use warnings;
use strict;

my $fi_snp_disease_vep ="match-all-snp-disease-5E-1";
open my $fh_snp_disease_vep, '<', $fi_snp_disease_vep or die "$0 : failed to open input file '$fi_snp_disease_vep' : $!\n";

while(<$fh_snp_disease_vep>)
{
    chomp;
    my @f= split /\t/;
     unless(/^EXTEND/){
          my $extend = $f[0];
          my $region = $f[4];
          my $symble = $f[5];
          my $variant_type = $f[7];
          if ($variant_type =~ /SNV/i){
              if($region =~/intron_variant|non_coding_transcript_variant|upstream_gene_variant|downstream_gene_variant|TFBS_amplification|TFBS_ablation|TF_binding_site_variant|regulatory_region_ablation|regulatory_region_amplification|feature_elongation|regulatory_region_variant|feature_truncation|intergenic_variant/){
                  print $_."\n"
              }
           #    else{print $_."\n"}
          }
         # else{print $_."\n"}
        }
}

