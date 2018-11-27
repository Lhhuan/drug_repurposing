#!/usr/bin/perl

use warnings;
use strict;

my $fi_step5result ="./step5-result-id-name-uniprot-moa";
my $fi_p_e ="./wgEncodeGencodeUniProtV24lift37.txt";
my $fi_e_e ="./ensGene.txt";


open my $fh_step5result, '<', $fi_step5result or die "$0 : failed to open input file '$fi_step5result' : $!\n";
open my $fh_p_e, '<', $fi_p_e or die "$0 : failed to open input file '$fi_p_e' : $!\n";
open my $fh_e_e, '<', $fi_e_e or die "$0 : failed to open input file '$fi_e_e' : $!\n";






my %hash1;
my %hash2;
my %hash3;
while(<$fh_step5result>)
{
    chomp;
    unless(/^ID/){
    my @f1 = split /\t/;
    my $uniprot_ID = $f1[2];
    my $drug = $f1[4];
    my $t = join "\t", @f1[0,1,3,4];
    push @{$hash1{$uniprot_ID}},$t;
    }
}




while(<$fh_p_e>)
{
    chomp;
  if (s/\.\d+//){
        my @f2 = split /\t/;
        my $UniprotID2 = $f2[1];
        my $ENSTID = $f2[0];
        $hash2{$UniprotID2}=$ENSTID;
     #   push @{$hash2 {$engeneID_T}},$UniprotID2;
    }
}

while(<$fh_e_e>)
{
    chomp;
   
    if (/EN\S/){
         my @f3 = split /\t/;
          if ($f3[0] !~/^$/){
         my $ENSTID = $f3[1];
         my $ENSGID = $f3[12];
           $hash3{$ENSTID}=$ENSGID;
          }
    }
}

foreach my $uniprot_ID (sort keys %hash1){
    if(exists $hash2{$uniprot_ID}){
        my @drugs = @{$hash1{$uniprot_ID}};
        my $ENSTID = $hash2{$uniprot_ID};
        if (exists $hash3{$ENSTID}){
            my $ENSGID = $hash3{$ENSTID};
            foreach my $drug(@drugs){
                print "$ENSGID\t$ENSTID\t$uniprot_ID\t$drug\n"
              # print "$ENSGID\t$ENSTID\n"
             }
            }
        }
    }
    