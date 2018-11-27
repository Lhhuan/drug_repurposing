#!/usr/bin/perl
use warnings;
use strict;


#my $fi_snp_disease ="./ALL_snp-disease";
#my $fi_snp_vep ="./all_snp_5E-1-vep";

my $fi_snp_disease ="ALL_snp-disease";
my $fi_snp_vep ="all-snp-5E-1-split-vep";
# my $fi_snp_disease ="snp";
# my $fi_snp_vep ="vep";


open my $fh_snp_disease, '<', $fi_snp_disease or die "$0 : failed to open input file '$fi_snp_disease' : $!\n";
open my $fh_snp_vep, '<', $fi_snp_vep or die "$0 : failed to open input file '$fi_snp_vep' : $!\n";



my $extend_snp;
my $k;
my %hash;
while(<$fh_snp_disease>)
{
    chomp;  
     my @f1 = split /\t/;
      unless (/^INDEX/){
           $extend_snp = $f1[1];
           $k = $f1[0];
          # print $k."\n"
        #    $k = join "\t", @f1[0,2..31];
            $hash{$extend_snp}=$k;
      }
}

while(<$fh_snp_vep>)
{
    chomp;
    my @f= split /\t/;
    # s/^\"//g;

    unless(/^POS/){
          unless(/^"Use/){
              my $extend = $f[0];
              my $region = $f[4];
              my $variant_type = $f[7];
             # print $extend."\n"
             #my $type = intron_variant|non_coding_transcript_variant|upstream_gene_variant|downstream_gene_variant|TFBS_amplification|TF_binding_site_variant|regulatory_region_ablation|regulatory_region_amplification|feature_elongation|regulatory_region_variant|feature_truncation|intergenic_variant
             my $m = join "\t", @f[1..4,7];
             my $t =  join "\t", @f[1..7]; 
                if(exists $hash{$extend}){
                    $k = $hash{$extend};
                    #print $extend."\n"
                    print $k."\n"

#                     #     if ($variant_type =~ /SNV/i){
#                     #        if($region =~/intron_variant|non_coding_transcript_variant|upstream_gene_variant|downstream_gene_variant|TFBS_amplification|TF_binding_site_variant|regulatory_region_ablation|regulatory_region_amplification|feature_elongation|regulatory_region_variant|feature_truncation|intergenic_variant/){
#                     #          #  print "$extend\t$t\t$k\n";
#                     #        }
#                     #            else{print $extend."\t".$t."\t". $k."\n"
#                     #    }
#                     #    }
#                     #   else{print $extend."\t".$t."\t". $k."\n"
#                     #   }
#                     #  }
#                     #   elsif ($variant_type =~ /SNV/i){
#                     #      # print $extend."\t".$m."\t".$k."\n"
#                     #    }
#                     #   else{ 
#                     #  # print $extend."\t".$m."\t". $k."\n"
#                     #     }
                    }
                }
           }
 #  }
}
  
    

# while(<$fh_snp_vep>)
# {
#     chomp;
#     my @f= split /\t/;
#     # s/^\"//g;

#     unless(/^POS/){
#           unless(/^"Use/){
#               my $extend = $f[0];
#               my $symble = $f[5];
#               my $variant_type = $f[7];
#               my $m = join "\t", @f[1..4,7];
#               my $t =  join "\t", @f[1..7]; 
#                 if(exists $hash{$extend}){
#                     $k = $hash{$extend};
#                     if ($symble !~/^$/){
#                         if ($variant_type =~ /SNV/i){
#                            # print "$extend\t$t\t$k\n";
                           
#                        }
#                       else{print $extend."\t".$t."\t". $k."\n"
#                       }
#                       }
#                       elsif ($variant_type =~ /SNV/i){
#                          # print $extend."\t".$m."\t".$k."\n"
#                        }
#                     #   else{ 
#                     #  # print $extend."\t".$m."\t". $k."\n"
#                     #     }
#                     }
#                 }
#            }
#  #  }
# }
  
    

      