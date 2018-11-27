#!/usr/bin/perl
use warnings;
use strict;
# my $fi_result ="./step5-snp_SNP-in-high-ld";
# open my $fh_result, '<', $fi_result or die "$0 : failed to open input file '$fi_result' : $!\n";

# while(<$fh_result>)
# {
#   s/^\s+//g;
#     unless(/^SNP/){
#      chomp;  
#       my @f1 = split /\s+/;
#       my $SNP = $f1[0];
#       my @tags = split /\|/,$f1[7];
#        foreach my $tags (@tags){
#           print $SNP."\t".$tags."\n"
#        }    
#     }
    
# }
my ($dirname, $filename);
$dirname = "../rdID-position/";        
opendir (DIR, $dirname ) || die "Error in opening dir $dirname\n";
 
while( ($filename = readdir(DIR))){
 
 
   open (FILE, "../rdID-position/".$filename)|| die "can not open the file $filename\n";
 
    while (<FILE>){
      chomp;
      s/^chr//g;
       my @f1 = split /\t/;
       my $chr = $f1[0];
       my $position =$f1[1];
       my $rsID = $f1[3];
     
       
          print $chr."_".$position."\t"."$rsID"."\n"      
      
   
  }
}
closedir(DIR);
