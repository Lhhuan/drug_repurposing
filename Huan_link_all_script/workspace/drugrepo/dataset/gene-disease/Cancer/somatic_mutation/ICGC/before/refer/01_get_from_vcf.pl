#!/usr/bin/perl
use warnings;
use strict;
use utf8;


my $fo1 = "./01_somatic.vcf";
my $fo2 = "./01_somatic_disease_occur.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
select $O1;
select $O2;
print "pos\tref\talt\tID\tdisease\toccurrence\ttested_donors\tfrequency\n";


open my $DATE, 'zless somatic.vcf.bed|' or die "zless somatic.vcf.bed $0: $!\n"; 
#open my $DATE, 'zless test.vcf.bed|' or die "zless test.vcf.bed $0: $!\n"; 

while(<$DATE>)
{

     chomp();  
      my @f1 = split /\s+/;
      my $chrom = $f1[0];
      my $pos = $f1[2];   #因为是bed格式，后面的才是原来vcf的碱基，经过查看验证这一点是正确的。
      my $ID = $f1[3];
      my $ref = $f1[5];
      my $alt = $f1[6];
      my $info = $f1[8];
      my @f = split /;/, $info; #首先将info中的信息用;分割
      my $occur = $f[1];
      my @f2 = split /\|/, $occur; #再将$occur用|分割
      my $disease = $f2[0];
      my $occurrence = $f2[1];
      my $tested_donors = $f2[2];
      my $frequency = $f2[3];
      if ($disease =~ s/OCCURRENCE=//g){
          print $O1  $chrom." ".$pos." \. ".$ref." ".$alt." \. \. \."."\n";
          print $O2  $chrom."_"."$pos\t$ref\t$alt\t$ID\t$disease\t$occurrence\t$tested_donors\t$frequency\n";
      }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";

