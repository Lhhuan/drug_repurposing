#!/usr/bin/perl
use warnings;
use strict;

# my $fi_tags ="./somatic.vcf.bed";
# open my $fh_tags, '<', $fi_tags or die "$0 : failed to open input file '$fi_tags' : $!\n";

open my $DATE, 'zless somatic.vcf.bed|' or die "zless somatic.vcf.bed $0: $!\n"; 

while(<$DATE>)
{

     chomp();  
      my @f1 = split /\s+/;
      my $chrom = $f1[0];
      my $pos = $f1[2];
      my $ID = $f1[3];
      my $ref = $f1[5];
      my $alt = $f1[6];
   
           
           #print $chrom."_".$pos."\t"..$ref."\t".$alt."\n"
           print $chrom." ".$pos." \. ".$ref." ".$alt." \. \. \."."\n";
         






}