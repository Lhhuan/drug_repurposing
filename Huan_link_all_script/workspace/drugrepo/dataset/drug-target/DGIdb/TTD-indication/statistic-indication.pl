#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./Result_TTDdrugid_drugname_disease.txt";
my $fo = "./TTD_statistic_indication.txt";


open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"statistic_indication.txt\n";
my %hash1;
while(<$I>)
{
   chomp;
   unless(/^TTDdrugID/){
       my @f = split/\t/;
       my $indication = $f[2];
       unless(exists $hash1{$indication}){
           print "$indication\n";
           $hash1{$indication} = 1;
       }
   }
}


close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

