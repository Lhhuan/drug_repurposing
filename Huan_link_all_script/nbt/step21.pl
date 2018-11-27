#!/usr/bin/perl

use warnings;
use strict;

my $fi_step1result ="./step1_drug_UniprotID_TTDtargetID_EnsembleID";
my $fi_mark_g_t ="./mart_export.txt";
my $fi_mim_enID ="./mim2gene.txt";


open my $fh_step1result, '<', $fi_step1result or die "$0 : failed to open input file '$fi_step1result' : $!\n";
open my $fh_mark_g_t, '<', $fi_mark_g_t or die "$0 : failed to open input file '$fi_mark_g_t' : $!\n";
open my $fh_mim_enID, '<', $fi_mim_enID or die "$0 : failed to open input file '$fi_mim_enID' : $!\n";


my %eid;
my %gtd;
my %emn;
my %tmp;
while(<$fh_step1result>)
{
    chomp;
    if (s/\.\d+//){
        my @f1 = split /\t/;
        my $ensembleID_T = $f1[3];
        my $drug = $f1[0];
        push @{$eid{$drug}},$ensembleID_T;
        my $t = join "\t", @f1[1,2];
        $tmp{$f1[3]}= $t;
    }
}

while(<$fh_mark_g_t>)
{
    chomp;
    if (/^ENS\S/){
        my @f2 = split /\t/;
        my $engeneID = $f2[0];
        my $entransID = $f2[1];
        $gtd{$entransID}=$engeneID;
    }
}

while(<$fh_mim_enID>)
{
    chomp;
   
    if (/EN\S/){
         my @f3 = split /\t/;
          if ($f3[0] !~/^$/){
         my $egeneID = $f3[4];
         my $MIMnumber1 = $f3[0];
         $emn{$egeneID}=$MIMnumber1;
          }
    }
}

foreach my $drug (sort keys %eid){
    my @ensembleID_T = @{$eid{$drug}};
    foreach my $ensembleID_T(@ensembleID_T){
        if( exists $gtd{$ensembleID_T}){
            my $engeneID =  $gtd{$ensembleID_T};
            if(exists $emn{$engeneID}){
                my $mimnumber = $emn{$engeneID};
               print  $drug."\t".$mimnumber."\t$tmp{$ensembleID_T}"."\n";
             # print  $drug."\t".$mimnumber."\t$tmp{$ensembleID_T}"."$ensembleID_T\t$engeneID\n";
            }
        }
    }
}







