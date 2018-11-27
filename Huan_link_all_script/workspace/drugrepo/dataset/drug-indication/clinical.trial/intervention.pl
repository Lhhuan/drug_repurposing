#!/usr/bin/perl 

use warnings;
use strict;


my $fi_interventions ="./interventions.txt";



open my $fh_interventions, '<', $fi_interventions or die "$0 : failed to open input file '$fi_interventions' : $!\n";


while (<$fh_interventions>)
{
 chomp;
 if($_ =~ /^[0-9]+/){
  #if($_ =~ /^[0-9]+\|.*$/){ 
      print "\n";
  }
  print;
}