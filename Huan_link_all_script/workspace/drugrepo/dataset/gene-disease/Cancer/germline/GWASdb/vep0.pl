#!/usr/bin/perl
use warnings;
use strict;


my $fi_tags ="./plink.tags-1E-5";
open my $fh_tags, '<', $fi_tags or die "$0 : failed to open input file '$fi_tags' : $!\n";
 while(<$fh_tags>)
{
  
     chomp;  
      my @f2 = split /_/;
      my $chr = $f2[0];
      my $POS = $f2[1];
      #print  $f2[1]."\n"
      my $pid = "$chr:$POS-$POS";
 # print "$pid\n";

my $line = `/f/Tools/htslib/htslib-1.5/tabix /f/mulinlab/ref_data/gnomad/gnomad.genomes.r2.0.1.sites.vcf.gz $pid`;
#open my $DATE, '/f/Tools/htslib/htslib-1.5/tabix /f/mulinlab/ref_data/gnomad/gnomad.genomes.r2.0.1.sites.vcf.gz $f2[0]:$f2[1]-$f2[1]|' or die "cannot pipe from /f/Tools/htslib/htslib-1.5/tabix /f/mulinlab/ref_data/gnomad/gnomad.genomes.r2.0.1.sites.vcf.gz 1:1079191-1079191 $0: $!\n"; 
#while(<$DATE>)
#{

     chomp($line);  
      my @f1 = split /\s+/,$line;
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
           my $vtype = $vep[22];
           print $chrom."_".$pos."\t".$ID."\t".$ref."\t".$alt."\t".$region."\t".$symbol."\t".$ENSG."\t".$vtype."\n"
          # print $region."\t".$symbol."\t".$ENSG."\t".$vtype."\n"


             }
          }
         
    #  }

}
