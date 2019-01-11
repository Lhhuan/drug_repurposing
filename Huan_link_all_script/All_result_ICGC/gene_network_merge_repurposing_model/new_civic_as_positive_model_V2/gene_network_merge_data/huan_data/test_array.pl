#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my @array = (1,2,3,4,5);
my %hash1;

my $k = "hello";

@{$hash1{$k}} = @array;

foreach my $k (sort keys %hash1){
    my @vs = @{$hash1{$k}};
    foreach my $v(@vs){
        print "$k\t$v\n";
    }
}