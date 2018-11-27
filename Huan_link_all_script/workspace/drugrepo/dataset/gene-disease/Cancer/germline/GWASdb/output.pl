#!/usr/bin/perl
use warnings;
use strict;


my $fi_result6 ="./step6-result";
my $fi_result5 ="./step5-snp_SNP-in-high-ld";
#my $fi_result5 ="./step5-phsae3-v5-highld";
open my $fh_result6, '<', $fi_result6 or die "$0 : failed to open input file '$fi_result6' : $!\n";
open my $fh_result5, '<', $fi_result5 or die "$0 : failed to open input file '$fi_result5' : $!\n";

open my $out,">" $fo;
select $out;
print "id\tchr\tst\ten\ts\n";
while
close $out;

my $position;
my $rsid ;

my %hash;

while(<$fh_result6>)
{

     chomp;  
      my @f1 = split /\t/;
       $position = $f1[0];
       $rsid = $f1[1];
       $hash{$position}=$rsid;
      # print $rsid."\n"
         
}
while(<$fh_result5>)
{

     chomp;  
      my @f2 = split /\t/;
      my $index_position = $f2[0];
      my $high_snp_position = $f2[1];
     #  print "123\n"
     if(exists $hash{$f2[0]}){
           print "$f2[0]\t$f2[1]\n";
     }
      #  if ( $position eq $high_snp_position) {
            
      #    print $index_position."\t".$high_snp_position."\t".$rsid."\n"
        
      # }
         
}