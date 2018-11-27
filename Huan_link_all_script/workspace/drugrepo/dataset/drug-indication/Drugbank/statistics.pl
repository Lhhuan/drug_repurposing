# #!/usr/bin/perl

# use warnings;
# use strict;

# my $fi_step1result ="./indication ";



# open my $fh_step1result, '<', $fi_step1result or die "$0 : failed to open input file '$fi_step1result' : $!\n";


  

# while(<$fh_step1result>)
# {
#     chomp;
   

         
#           if ($_ !~/N\/A/){
#          print $_."\n"
#           }
    
# }



#!/usr/bin/perl

use warnings;
use strict;

my $fi_result ="./Drug_Claim_Drugbank_2016_06_28.txt";



open my $fh_result, '<', $fi_result or die "$0 : failed to open input file '$fi_result' : $!\n";


  

while(<$fh_result>)
{
    chomp;
    my @f1 = split /\t/;
   
     if ($f1[3] !~/N\/A/){
         my $indication = $f1[3];
         my $drug = $f1[0];
     print $drug."\t".$indication."\n"
    # print $indication."\n"
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