#将三个source 的driver（../DoCM/version_3.2/variants.tsv, ../29625053_Comprehensive/driver_mutation.txt 和 ../29533785_system/mutation.txt）
#merge到一起,得./output/three_source_driver.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../DoCM/version_3.2/variants.tsv";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "../29625053_Comprehensive/driver_mutation.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 = "../29533785_system/mutation.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 = "./output/three_source_driver.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    if(/^hgvs/){
        print $O1 "$_\tSource\n"
    }
    else{
        print $O1 "$_\tDoCM\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Gene/){
        my $gene = $f[0];
        my $Mutation =$f[2];
        my $output = "NA\tNA\tNA\tNA\tNA\tNA\tNA\t$gene\tNA\t$Mutation\tNA\tNA\t29625053_Comprehensive";
        print $O1 "$output\n";
    }
}

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Gene/){
        my $gene = $f[0];
        my $Mutation =$f[1];
        if ($f[-1]=~/\bactivating\b/){
            my $output = "NA\tNA\tNA\tNA\tNA\tNA\tNA\t$gene\tNA\t$Mutation\tNA\tNA\t29533785_system";
            print $O1 "$output\n";
        }
    }
}


