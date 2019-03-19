#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi_dictionary = "./molecule_dictionary.txt";
my $fi_indication = "./drug-indication.txt";
my $fo1 = "./step3_result.txt";

open my $I1, '<', $fi_dictionary or die "$0 : failed to open input file '$fi_dictionary' : $!\n";
open my $I2, '<', $fi_indication or die "$0 : failed to open input file '$fi_indication' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;
my %hash2;
print $O1 "drugind_id\trecord_id\tmax_phase_for_ind\tmesh_id\tmesh_heading\tefo_id\tefo_term\tmolregno\tpref_name\tchembl_id\tmax_phase\tmolecule_type\n";

while(<$I1>)
{
   chomp;
   if(/^\d+/){
        my @f = split/\t/;
        my ($molregno, $pref_name, $chembl_id, $max_phase, $molecule_type) = ($f[0], $f[1], $f[2], $f[3], $f[8]);
        my $k = join"\t",@f[1..3, 8];
        push @{$hash1{$molregno}},$k;
        }
}

while(<$I2>)
{
   chomp;
   if(/^\d+/){
        my @f = split/\t/;
        my ($drugind_id, $record_id, $molregno, $max_phase_for_ind, $mesh_id, $mesh_heading, $efo_id, $efo_term) = ($f[0], $f[1], $f[2], $f[3], $f[4], $f[5], $f[6], $f[7]);
        my $t = join"\t",@f[0, 1, 3..7];
        push @{$hash2{$molregno}},$t;
        }
}

  foreach my $molregno(sort keys %hash1){
        if(exists $hash2{$molregno}){ 
            my @k = @{$hash1{$molregno}};
            my @t = @{$hash2{$molregno}};
            foreach my $t(@t){
                foreach my $k(@k){
                    print $O1 "$t\t$molregno\t$k\n"
            
                }
           }     
       }
  }



