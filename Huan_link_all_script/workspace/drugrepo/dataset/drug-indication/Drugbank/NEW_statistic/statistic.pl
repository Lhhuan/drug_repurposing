

#!/usr/bin/perl

use warnings;
use strict;

my $fi_result ="./Drug_Claim_Drugbank_2017_11_17.txt";



open my $fh_result, '<', $fi_result or die "$0 : failed to open input file '$fi_result' : $!\n";


  

while(<$fh_result>)
{
    chomp;
    my @f1 = split /\t/;
    unless (/^Drug_Name/){
        if ($f1[7] !~/N\/A/){
            my $indication = $f1[7];
           # my $drug = $f1[0];
            #print $drug."\t".$indication."\n"
    print $_."\n"
    }
   }
}


# while(<$fh_mim_enID>)
# {
#     chomp;
   
#     if (/EN\S/){
#          my @f3 = split /\t/;
#           if ($f3[0] !~/^$/){
#          my $egeneID = $f3[4];
#          my $MIMnumber1 = $f3[0];
#          $emn{$egeneID}=$MIMnumber1;
#           }
#     }
# }