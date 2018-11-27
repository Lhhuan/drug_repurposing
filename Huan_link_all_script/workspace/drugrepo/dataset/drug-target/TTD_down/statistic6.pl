#!/usr/bin/perl

use warnings;
use strict;

my $fi_step5result ="./step6-result";


open my $fh_step5result, '<', $fi_step5result or die "$0 : failed to open input file '$fi_step5result' : $!\n";


while(<$fh_step5result>)
{
    chomp;
    unless(/^ENSGID/){
    my @f1 = split /\t/;
    my $ENSGID = $f1[0];
    my $drug = $f1[6];
    print $drug."\n"
    }
}