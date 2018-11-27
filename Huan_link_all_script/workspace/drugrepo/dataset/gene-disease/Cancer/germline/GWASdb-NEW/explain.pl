#!/usr/bin/perl
use warnings;
use strict;


my $fi_tags ="./ref-alt-extend-1E-5-vep.vcf-";
open my $fh_tags, '<', $fi_tags or die "$0 : failed to open input file '$fi_tags' : $!\n";
 while(<$fh_tags>)
{

     chomp();  
     unless(/^\#/){
      my @f1 = split /\s+/ ;
      my $chrom = $f1[0];
      my $pos = $f1[1];
      my $ID = $f1[2];
      my $ref = $f1[3];
      my $alt = $f1[4];
      my $info = $f1[7];
      #my @information = split /;/,$f1[7];
     # my $CSQ = $information[83];
     # print $CSQ."\n"
     # my @csq =  split /\,/,$information[83];
      if($info=~/CSQ=(.+?)(;.+?)?$/){
      #  print "$1\n";
      # }
      #  exit;
      my @csq =  split /,/, $1;
    #  my $vep1 = $csq[0];
      foreach my $csq (@csq){
      # print $csq."\n";
         my @vep = split /\|/,$csq;
        
           my $region = $vep[1];
           my $symbol = $vep[3];
           my $ENSG = $vep[4];
          # my $vtype = $vep[22];
           print $chrom."_".$pos."\t".$ID."\t".$ref."\t".$alt."\t".$region."\t".$symbol."\t".$ENSG."\t"."SNV"."\n"
           #print $chrom."_".$pos."\n"


             }
          }
         
      }

}
