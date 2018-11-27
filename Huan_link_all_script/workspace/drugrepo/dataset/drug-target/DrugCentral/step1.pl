#!/usr/bin/perl
use warnings;
use strict;
my $fi_drugcentral ="act_table_full-after.txt";
open my $fh_drugcentral, '<', $fi_drugcentral or die "$0 : failed to open input file '$fi_drugcentral' : $!\n";


while(<$fh_drugcentral>)
{
    chomp;
         if (/^\d+/){
             my @f1 = split /\t/;
             my $strict_id = $f1[1];
             my $target_id = $f1[2];
             my $target_name = $f1[3];
             my $target_class = $f1[4];
             my $accession = $f1[5];
             my $gene = $f1[6];
             my $swissprot = $f1[7];
             my $act_source = $f1[12];
             my $act_source_url = $f1[16];
             my $action = $f1[18];

          
     # print "$f1[1..7]\t$f1[12]\t$f1[16]\t$f1[18]\n"
     print "$f1[1]\t$f1[2]\t$f1[3]\t$f1[4]\t$f1[5]\t$f1[6]\t$f1[18]\t$f1[7]\t$f1[12]\t$f1[16]\n"
             }
          }
   