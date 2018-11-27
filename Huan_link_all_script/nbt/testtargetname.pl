#!/usr/bin/perl

use warnings;
use strict;

my $fi_ttd ="./TTD_download.txt";
my $fi_drug_targetid_name ="./step3_mismatch_targetid_indication_drug_mimnumber_disorder_uniprotid";

open my $fh_ttd, '<', $fi_ttd or die "$0 : failed to open input file '$fi_ttd' : $!\n";
open my $fh_drug_targetid_name, '<', $fi_drug_targetid_name or die "$0 : failed to open input file '$fi_drug_targetid_name' : $!\n";
 my %tid;
 my %t2d;
      
  while (<$fh_ttd>)
      {
        chomp;
         if (/Name/){
             my @f3 = split /\t/;
             my $TTDTargetID3 = $f3[0];
             my $targetname = $f3[2];
            $t2d{$TTDTargetID3}=$targetname;
         }
      }
      

while(<$fh_drug_targetid_name>)
{
    chomp;
    
        my @f1 = split /\t/;
        my $targetid = $f1[0];
        my $data1 = join "\t", @f1[1,2,3,4,5];
        push @{$tid{$targetid}},$data1;
           
}


foreach my $id (sort keys %t2d){
      if( exists $tid{$id}){
             my @data = @{$tid{$id}};
             my $targetname = $t2d{$id};
         foreach my $data(@data){
                print  $id."\t".$targetname."\t".$data."\n";
         }
      }
}