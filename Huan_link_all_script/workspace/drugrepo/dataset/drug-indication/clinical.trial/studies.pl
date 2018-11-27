#!/usr/bin/perl

use warnings;
use strict;


my $fi_studies ="./studies.txt";

open my $fh_studies, '<', $fi_studies or die "$0 : failed to open input file '$fi_studies' : $!\n";



while (<$fh_studies>)
{
  chomp;
  if($_ =~ /^NCT0\S/){ 
     # if($_ =~ /^NCT0+\|.*$/){ 
      print "\n";
  }
  print;
}