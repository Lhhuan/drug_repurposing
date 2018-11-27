#!/usr/bin/perl
use warnings;
use strict;
my $fi_action ="step1_result_action";
my $fi_drug ="active_ingredient.txt";
open my $fh_action, '<', $fi_action or die "$0 : failed to open input file '$fi_action' : $!\n";
open my $fh_drug, '<', $fi_drug or die "$0 : failed to open input file '$fi_drug' : $!\n";

my %hash1;
my %hash2;

while(<$fh_action>)
{
    chomp;
    if(/^\d+/){
        my @f1 = split /\t/;
        my $struct_id = $f1[0];
        my $k = join "\t", @f1[1..9];
        push @{$hash1{$struct_id}},$k;
    }
}    


while(<$fh_drug>)
{
    chomp;
    if (/^\d+/){
        my @f2 = split /\t/;
        my $struct_id2 = $f2[8];
        my $active_moiety_name = $f2[2];
        my $substance_name = $f2[6];
        my $t = join "\t", @f2[2,6];
        $hash2{$struct_id2}=$t;
    }
}

 

foreach my $struct_id (sort keys %hash1){
    if (exists $hash2{$struct_id}){
            my @k = @{$hash1{$struct_id}};
            my $t =$hash2{$struct_id} ;
            foreach my $k(@k){
                print "$struct_id\t$t\t$k\n"
            }
    }
}

      