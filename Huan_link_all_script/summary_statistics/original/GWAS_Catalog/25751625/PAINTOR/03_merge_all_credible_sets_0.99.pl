#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
use Parallel::ForkManager; #多线程并行


my $fo2 ="./credible_sets_0.99_chr_pos_ref_alt.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open input file '$fo2' : $!\n";
print $O2 "chr\tpos\tref\talt\tsource_ID\n";
my %hash1;

my $f2 = "./all_credible_sets_0.99.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
while(<$I2>){
    chomp;
    unless(/^chromosome/){
        my @sf = split/\t/;
        my $chr = $sf[0];
        my $pos = $sf[1]; 
        my $ref = $sf[3];
        my $alt = $sf[5];
        print $O2 "$chr\t$pos\t$ref\t$alt\t25751625\n";
    }   
}