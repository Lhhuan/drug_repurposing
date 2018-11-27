#!/usr/bin/perl
use warnings;
use strict;


#my $fi_result ="./tags.list-5E-8_500kb_0.8";
my $fi_result ="./plink.tags.list-1E-5";
#my $fi_result ="/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/germline/1kg_phase3_v5/1kg_phase3_v5/EUR/plink.tags.list_1E-5_500kb_0.8";

open my $fh_result, '<', $fi_result or die "$0 : failed to open input file '$fi_result' : $!\n";

while(<$fh_result>)
{
  s/^\s+//g;
    unless(/^SNP/){
     chomp;  
      my @f1 = split /\s+/;
      my $SNP = $f1[0];
       unless ($f1[7]=~ /NONE/){
      my @tags = split /\|/,$f1[7];
       foreach my $tags (@tags){
        #  print $SNP."\t".$tags."\n"
          print $tags."\n"
                    
       }    
    }
 }   
}