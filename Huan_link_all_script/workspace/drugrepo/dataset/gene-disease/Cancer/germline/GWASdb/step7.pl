#!/usr/bin/perl
use warnings;
use strict;



my $fi_snp_single ="./ALL_snp-disease";
#my $fi_snp_single ="./step8-1E-5result-index-highld";

open my $fh_snp_single, '<', $fi_snp_single or die "$0 : failed to open input file '$fi_snp_single' : $!\n";


while(<$fh_snp_single>)
{
    chomp;
    my @f = split /\t/;
    my $gwas_trait = $f[16];
    my $k = join "\t", @f[0..15,17..31];
    print $gwas_trait."\t".$k."\n"
 #print $f[16]."\t".$f[1]."\n"
}
