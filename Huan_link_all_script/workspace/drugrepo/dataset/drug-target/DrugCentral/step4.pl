#!/usr/bin/perl

use warnings;
use strict;

my $fi_step3result ="./step3_result";

open my $fh_step3result, '<', $fi_step3result or die "$0 : failed to open input file '$fi_step3result' : $!\n";

while(<$fh_step3result>)
{
    chomp;
    unless(/^ENSGID/){
        my @f1 = split /\t/;
        unless($f1[10] =~ /\\N/){
            print $_."\n"
        }
    }
}