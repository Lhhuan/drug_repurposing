#!/usr/bin/perl

use warnings;
use strict;


my $fi_indication_disorder ="./step312_targetid_targetname_indication_drug_mimnumber_disorder_uniprotid";
open my $fh_indication_disorder, '<', $fi_indication_disorder or die "$0 : failed to open input file '$fi_indication_disorder' : $!\n";

my %hash1;
my %hash2;

my @a;
my %h;
while(<$fh_indication_disorder>)
{
    chomp;  
    push @a,$_;
      my @f1 = split /\t/;
        
      $f1[2] =~ s/\(//g;
      $f1[2] =~ s/\)//g;
      $f1[2] =~ s/,//g;
      $f1[2] =~ s/;//g;
      $f1[2] =~ s/-//g;
      my @indication = split /\s+/,$f1[2];
       my $disorder = $f1[5];
      foreach $disorder (@indication){
          if( $f1[5] =~ /\b$disorder\b/i){
               $h{$_}=1;
           
          }         
        
       }
}

foreach my $e (@a){
    if(exists $h{$e}){
        print $e."\n";
   
}
    
    else{
      #  print $e."\n";
   }

}








# foreach my $e (@a){
#     if(exists $h{$e}){

#        # my @f2 = split /\t/;
#      # my  $key1 =$f2[0];
#        # my $key1 = $f2[0]."\t".$f2[1]."\t".$f2[4]."\t".$f2[2]."\t".$f2[3]."\n" ;

#  print $e."\n";
#     # print $key1."\n";
# }
    
#     else{
#         print $e."\n";
#    }




