#!/usr/bin/perl
use warnings;
use strict;


my $fi_tags ="./match_line_result_unvep_index_snp_1e-5";
open my $fh_tags, '<', $fi_tags or die "$0 : failed to open input file '$fi_tags' : $!\n";
 while(<$fh_tags>)
{
  
     chomp;  
      my @f2 = split /_/;
      my $chr = $f2[0];
      my $POS = $f2[1];
    #  print  $f2[1]."\n"
       my $pid = "$chr:$POS-$POS";
 #  print "$pid\n";

my $line = `/f/Tools/htslib/htslib-1.5/tabix  /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/germline/1kg_phase3_v5/1kg_phase3_v5/EUR/1kg.phase3.v5.shapeit2.eur.hg19.all.SNPs.IDS.uniq.vcf.bgz.gz  $pid`;


     chomp($line);  
      my @f1 = split /\s+/,$line;
      my $chrom = $f1[0];
      my $pos = $f1[1];
    #  my $ID = $f1[2];
      my $ref = $f1[3];
      my $alt = $f1[4];
   
           
           #print $chrom."_".$pos."\t"..$ref."\t".$alt."\n"
           print $chrom." ".$pos." \. ".$ref." ".$alt." \. \. \."."\n"
         


}
