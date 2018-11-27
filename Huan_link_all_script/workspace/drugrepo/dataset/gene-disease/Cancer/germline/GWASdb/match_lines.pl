#!/usr/bin/perl
use warnings;
use strict;


my $fi_tags ="./plink.tags-1E-5";
my $fi_lines ="./no_gnomad_vep_extend-snp_line";
# my $fi_tags ="test";
# my $fi_lines ="testline";
open my $fh_tags, '<', $fi_tags or die "$0 : failed to open input file '$fi_tags' : $!\n";
open my $fh_lines, '<', $fi_lines or die "$0 : failed to open input file '$fi_lines' : $!\n";

my @lines;


while(<$fh_lines>)
{
    chomp;  
    push @lines ,$_ ;
    
}

my $n = 1;
while(<$fh_tags>)
{
    chomp;  
    #$n = 1;
    foreach my $line(@lines){
        if ( $n eq $line){
        print $_."\n"
        } 
    }
    $n++ ;
}


