#!/usr/bin/perl
use warnings;
use strict;

my $fi_snp_disease ="345";
 my $fi_snp_vep ="456";


open my $fh_snp_disease, '<', $fi_snp_disease or die "$0 : failed to open input file '$fi_snp_disease' : $!\n";
open my $fh_snp_vep, '<', $fi_snp_vep or die "$0 : failed to open input file '$fi_snp_vep' : $!\n";

my @f1;
while(<$fh_snp_vep>)
{
    chomp;  
    
  push @f1,$_;
   

}

 while(<$fh_snp_disease>)
 {
     chomp;  
     my $flag = 0;
     foreach my $f(@f1) {
        $flag++ if($_ eq $f )
     }
               print $_."\n" if $flag == 0;
        }
            
 