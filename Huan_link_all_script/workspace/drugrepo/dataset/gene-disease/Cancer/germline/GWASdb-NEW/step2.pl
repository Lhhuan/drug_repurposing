#!/usr/bin/perl
use warnings;
use strict;


my $fi_result1 ="./step1-result";
open my $fh_result1, '<', $fi_result1 or die "$0 : failed to open input file '$fi_result1' : $!\n";


 
    





while(<$fh_result1>)
{
    chomp;  
  
      my @f1 = split /\t/;
     # if ($f1[18] =~ /Neoplasms|Neoplasm|Cancers|Cancer|Neoplasia|Tumors|Tumor|Carcinoma|Melanoma|Sarcoma/i){
        # my $HPO_TERM = $f1[16];
        # my $DO_TERM = $f1[18];
        # my $MESH_TERM = $f1[20];
        # my $EFO_TERM = $f1[22];
        # my $DOLITE_TERM = $f1[23];
        # print $f1[1]."\n"
      # print $f1[0]."_".$f1[1]."\n"
       print $f1[0]."_".$f1[1]."\t".$f1[0]."_".$f1[1]."\t".$_."\n"
}
