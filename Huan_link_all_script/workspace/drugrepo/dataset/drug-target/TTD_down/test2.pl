#!/usr/bin/perl

use warnings;
use strict;


my $fi_indication_disorder ="./test1-re";
my $fi_1 ="P2-01-TTD_uniprot_all.txt";

open my $fh_indication_disorder, '<', $fi_indication_disorder or die "$0 : failed to open input file '$fi_indication_disorder' : $!\n";
open my $fh_1, '<', $fi_1 or die "$0 : failed to open input file '$fi_1' : $!\n";



my @name;
my @a;

while(<$fh_indication_disorder>)
{
    chomp;  
  #  push @a,$_;
      my @f1 = split /\t/;
   
 #  push @name = split /\s+/,$f1[2];
     @name = split /;/,$f1[2];

    # @name = split /;/,$f1[2];
     foreach my $m(@name){
         push @a,$m;
     }
}

while(<$fh_1>)
{
    chomp;  
     unless(/^TTD/){
         if (/^T/){
             my @f1 = split /\t/;
             foreach my $n(@a){
                 if (exists $f1[1] eq $n){
                     #print $f1[0]."\t".$f1[1]."\t".$n."\n"
                     print $f1[0]."\n"
                 }
             }
            }
      }
}





# while(<$fh_indication_disorder>)
# {
#     chomp;  
#     push @a,$_;
#       my @f1 = split /\t/;
        
#       $f1[1] =~ s/\(//g;
#       $f1[1] =~ s/\)//g;
#       $f1[1] =~ s/,//g;
#       $f1[1] =~ s/;//g;
#       $f1[1] =~ s/-//g;
#       my @indication = split /\s+/,$f1[1];
#        my $disorder = $f1[4];
#       foreach $disorder (@indication){
#           if( $f1[4] =~ /\b$disorder\b/i){
#                $h{$_}=1;  
#           }         
#        }
# }

# foreach my $e (@a){
#     if(exists $h{$e}){
#         print $e."\n";
#     }
#     else{
#       #  print $e."\n";
#    }
# }


