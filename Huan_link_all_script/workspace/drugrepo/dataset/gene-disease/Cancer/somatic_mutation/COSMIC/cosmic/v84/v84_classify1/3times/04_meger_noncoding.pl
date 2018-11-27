#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./CosmicNonCodingMuts_largethan2_nm_vep_true_noncoding.txt";
my $f2 ="./CosmicCodingMuts_largethan2_nm_vep_true_noncoding.txt";

my $fo1 = "./Cosmic_all_noncoding.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "ID\tAlt_allele\tlocation\tENSG_ID\tvariant_type\tsymbol\n";
select $O1;
print $title;
# select $O2;
# print $title;
 my (%hash1,%hash2,%hash3,%hash4,%hash5);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $k1= $_;
         unless(exists $hash1{$k1}){
             print $O1 "$k1\n";
             $hash1{$k1} = 1;
        }   
     }
}   
            
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $k1= $_;
         unless(exists $hash1{$k1}){
             print $O1 "$k1\n";
             $hash1{$k1} = 1;
        }   
     }
}           
