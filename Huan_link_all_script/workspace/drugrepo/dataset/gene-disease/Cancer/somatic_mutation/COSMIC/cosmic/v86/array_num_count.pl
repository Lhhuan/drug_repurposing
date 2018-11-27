#!/usr/bin/perl
use warnings;
use strict;
use utf8;  
my $fo1 = "./array_count.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $f1 = "./all_test_sampleid.txt";
open my $I1, '<', $f1 or die "$0 : failed to open output file '$f1' : $!\n";
my %hash1;

while(<$I1>)
{
    unless (/^sample_name/){
     chomp();  
      my @f1 = split /\s+/;
      my $sample_name = $f1[0];
      my $pos = $f1[4];
      push @{$hash1{$pos}},$sample_name;
    }
}

foreach my $ID (sort keys %hash1){
    my @nums = @{$hash1{$ID}};
    my $num1 = @nums;
    my %hash2;
    @nums = grep { ++$hash2{$_} < 2 } @nums;
    my $num2 = @nums;
    print $O1 "$ID\t$num1\t$num2\n";
}