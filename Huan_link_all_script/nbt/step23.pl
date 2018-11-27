#!/usr/bin/perl

use warnings;
use strict;

my $fi_step21result ="./step21_drug_mimnumber_uniprotid_targetid";

open my $fh_step21result, '<', $fi_step21result or die "$0 : failed to open input file '$fi_step21result' : $!\n";

while(<$fh_step21result>)
  {
       chomp;
        my @f = split /\t/;
        my $drug = $f[0];
        my $target = $f[3];
      print $target."\n";
  }