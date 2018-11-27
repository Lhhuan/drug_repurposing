#!/usr/bin/perl

use warnings;
use strict;

my $fi_target_disease ="./target-disease_TTD2013.txt";
my $fi_drug_disorder_target ="./step2_drug_mimnumber_disorder_uniprotid_targetid";

open my $fh_target_disease, '<', $fi_target_disease or die "$0 : failed to open input file '$fi_target_disease' : $!\n";
open my $fh_drug_disorder_target, '<', $fi_drug_disorder_target or die "$0 : failed to open input file '$fi_drug_disorder_target' : $!\n";

my %tdi;
my %drt;

while(<$fh_target_disease>)
{
   chomp;
    
        my @f1 = split /\t/;
        my $Ttdtargetid = $f1[0];
        my $Indication = $f1[2];
        my $targetname = $f1[1];
        my $ti = join "\t", @f1[1,2];
        push @{$tdi{$Ttdtargetid}},$ti;
}

  while(<$fh_drug_disorder_target>)
{
   chomp;
    
        my @f2 = split /\t/;
        my $target = $f2[4];
         my $t = join "\t", @f2[0,1,2,3];
        push @{$drt{$target}},$t;
}


foreach my $Ttdtargetid (sort keys %tdi){
    if (exists $drt{$Ttdtargetid}){
        my @targetname_indication = @{$tdi{$Ttdtargetid}};
        my @data = @{$drt{$Ttdtargetid}};
        foreach my $targetname_indication(@targetname_indication){
            foreach my $data(@data){
                print $Ttdtargetid."\t".$targetname_indication."\t".$data."\n";
            }
        }


    }
}