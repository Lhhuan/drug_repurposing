
#!/usr/bin/perl
use warnings;
use strict;

my $fi_snp_disease_vep ="step9-result-mix";
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
        if($region =~/mature_miRNA_variant|non_coding_transcript_exon_variant/){
                   if ($symble =~ /^$/){
                       print $_."\n"
                   }
                  # else{print $_."\n"}
        }
    }
}