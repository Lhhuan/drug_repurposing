#!/usr/bin/perl
use warnings;
use strict;


my $fi_tags ="./all_credible_sets_0.95.txt";
open my $fh_tags, '<', $fi_tags or die "$0 : failed to open input file '$fi_tags' : $!\n";
my $fo2 ="./all_credible_sets_0.95_ref_alt.txt"; #最终输出结果文件 #每个drug hit 到disease 时，所hit到的gene
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";  
 while(<$fh_tags>)
{
  
     chomp;  
     unless(/^chromosome/){
      my @f2 = split /\t/;
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
           print $O2 "$chrom\t$pos\t$ref\t$alt";
     }
}
