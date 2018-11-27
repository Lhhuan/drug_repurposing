#!/usr/bin/perl
use warnings;
use strict;
my $fi_drugcentral ="step4-result";
open my $fh_drugcentral, '<', $fi_drugcentral or die "$0 : failed to open input file '$fi_drugcentral' : $!\n";


while(<$fh_drugcentral>)
{
    chomp;
         unless (/^ENSGID/){
             my @f1 = split /\t/;
             my $ENSGID = $f1[0];
             my $struct_id = $f1[3];
             print $struct_id."\n"
             }
          }
   