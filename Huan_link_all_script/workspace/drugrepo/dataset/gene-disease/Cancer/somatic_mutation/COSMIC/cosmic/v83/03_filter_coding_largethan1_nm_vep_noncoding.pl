#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./CosmicCodingMuts_largethan1_nm_vep_noncoding.txt";
my $f2 ="./CosmicCodingMuts_largethan1_nm_vep_coding.txt";

my $fo1 = "./CosmicCodingMuts_largethan1_nm_vep_true_noncoding.txt";
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
         my $location = $f[2];
         push @{$hash1{$location}},$_;
     }
}   
            
          
while(<$I2>)
{
   chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $location = $f[2];
         push @{$hash2{$location}},$_;
     }
}

foreach my $location(sort keys %hash1){
       unless(exists $hash2{$location}){ 
            my @v1 = @{$hash1{$location}};
            foreach my $v1(@v1){
            print "$v1\n";
            }
       }
}

                
                    