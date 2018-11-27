#!/usr/bin/perl
use warnings;
use strict;



 my $fi_high_ld ="./step4_index-extend_snp_1E-5";
 my $fi_index_disease ="./step2_result_index_pos_disease";
# my $fi_high_ld ="456";
# my $fi_index_disease ="./567";

open my $fh_high_ld, '<', $fi_high_ld or die "$0 : failed to open input file '$fi_high_ld' : $!\n";
open my $fh_index_disease, '<', $fi_index_disease or die "$0 : failed to open input file '$fi_index_disease' : $!\n";

my %hash;
while(<$fh_high_ld>)
{
    unless(/^INDEX-snp/){
    chomp;
    my @f = split /\t/;
    push @{$hash{$f[0]}},$f[1];
    }
}  



while(<$fh_index_disease>)
{
   if (/^\S/){
    chomp;  
        my @f = split /\t/;
        # my $HPO_TERM = $f1[17];
        # my $DO_TERM = $f1[19];
        # my $MESH_TERM = $f1[21];
        # my $EFO_TERM = $f1[23];
        # my $DOLITE_TERM = $f1[24];
        my $k = join "\t", @f[1..30];
         

         if(exists $hash{$f[0]}){
             my @high_ld_snp = @{$hash{$f[0]}};
             foreach my $high_snp(@high_ld_snp){
                 print $f[0]."\t".$high_snp."\t".$k."\n";
                 }
 
          }
   } 
  }
