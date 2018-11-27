#!/usr/bin/perl

use warnings;
use strict;

my $fi_step1result ="./step1_drug_UniprotID_TTDtargetID_EnsembleID";
my $fi_mark_g_t ="./mart_export.txt";
my $fi_mim_enID ="./mim2gene.txt";
my $fi_mim_dis ="./genemap";


open my $fh_step1result, '<', $fi_step1result or die "$0 : failed to open input file '$fi_step1result' : $!\n";
open my $fh_mark_g_t, '<', $fi_mark_g_t or die "$0 : failed to open input file '$fi_mark_g_t' : $!\n";
open my $fh_mim_enID, '<', $fi_mim_enID or die "$0 : failed to open input file '$fi_mim_enID' : $!\n";
open my $fh_mim_dis, '<', $fi_mim_dis or die "$0 : failed to open input file '$fi_mim_dis' : $!\n";
 

my %eid;
my %gtd;
my %emn;
my %m_d;
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

while(<$fh_mim_dis>)
{
    chomp;
     my @f4 = split /\|/;
     if ($f4[13] !~/^$/){
        my $MIMnumber2 = $f4[9];
        my $disorder = $f4[13];
        push @{$m_d{$MIMnumber2}},$disorder;
    }
}

foreach my $drug (sort keys %eid){
    my @ensembleID_T = @{$eid{$drug}};
    foreach my $ensembleID_T(@ensembleID_T){
        if( exists $gtd{$ensembleID_T}){
            my $engeneID =  $gtd{$ensembleID_T};
            if(exists $emn{$engeneID}){
                my $mimnumber = $emn{$engeneID};
                if (exists $m_d{$mimnumber}){
                     my @disorder =@{$m_d{$mimnumber}};
                     foreach my $disorder(@disorder){
               print  $drug."\t".$mimnumber."\t".$disorder."\t$tmp{$ensembleID_T}"."\n";
                          }
                  }
               }
          }
       }
}




