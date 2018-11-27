#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./simple_somatic_mutation.largethan1.nm.vep.vcf";

my $fo1 = "./simple_somatic_mutation_largethan1_nm_vep_noncoding.txt";
my $fo2 = "./simple_somatic_mutation_largethan1_nm_vep_coding.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $title = "ID\tAlt_allele\tlocation\tENSG_ID\tvariant_type\tsymbol\n";
select $O1;
print $title;
select $O2;
print $title;
 my (%hash1,%hash2,%hash3,%hash4,%hash5);
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^#/){
         unless($f[2] =~ /-/){  #不要insertion的
             unless($f[1] =~ /-/){  #不要deletion的
                 my $ID = $f[0];
                 my $location = $f[1];
                 my $alt_allele = $f[2];
                 my $ENSG_ID = $f[3];
                 my $variant_type = $f[6];
                 my $extra = $f[13];
                 my @fs = split /;/,$extra;
                 my @fv = split/\,/,$variant_type;
                 foreach my $variant(@fv){
                     if ($variant =~/intron_variant|non_coding_transcript_variant|upstream_gene_variant|downstream_gene_variant|TFBS_amplification|TFBS_ablation|TF_binding_site_variant|regulatory_region_ablation|regulatory_region_amplification|feature_elongation|regulatory_region_variant|feature_truncation|intergenic_variant/){
                        if ($ENSG_ID =~ /-/){
                             my $symbol = "NA";
                             my $header = "$ID\t$alt_allele\t$location\t$ENSG_ID\t$variant\t$symbol";
                             unless(exists $hash1{$header}){
                                print $O1 "$header\n";
                                $hash1{$header} = 1;
                             }
                        }
                        else{
                            foreach my $i(@fs){
                                if ($i=~/SYMBOL=/){
                                     my @fg = split /=/,$i;
                                     my $symbol = $fg[1];
                                     my $header = "$ID\t$alt_allele\t$location\t$ENSG_ID\t$variant\t$symbol";
                                     unless(exists $hash2{$header}){
                                         print $O1 "$header\n";
                                         $hash2{$header} = 1;
                                    }
                                }
                            } 
                        }
                     }
                     elsif($variant =~/mature_miRNA_variant|non_coding_transcript_exon_variant/){
                         if($ENSG_ID =~ /-/){
                             my $symbol = "NA";
                             my $header = "$ID\t$alt_allele\t$location\t$ENSG_ID\t$variant\t$symbol";
                             unless(exists $hash3{$header}){
                                print $O1 "$header\n";
                                $hash3{$header} = 1;
                             }
                        }
                        else{
                            foreach my $i(@fs){
                                if ($i=~/SYMBOL=/){
                                     my @fg = split /=/,$i;
                                     my $symbol = $fg[1];
                                     my $header = "$ID\t$alt_allele\t$location\t$ENSG_ID\t$variant\t$symbol";
                                     unless(exists $hash4{$header}){
                                         print $O2 "$header\n";
                                         $hash4{$header} = 1;
                                    }
                                }
                            } 
                        }
                     }
                    else{
                        foreach my $i(@fs){
                                if ($i=~/SYMBOL=/){
                                     my @fg = split /=/,$i;
                                     my $symbol = $fg[1];
                                     my $header = "$ID\t$alt_allele\t$location\t$ENSG_ID\t$variant\t$symbol";
                                     unless(exists $hash5{$header}){
                                         print $O2 "$header\n";
                                         $hash5{$header} = 1;
                                    }                 
                                }
                        } 
                    }
                 }
             }
         }
     }
}
          
