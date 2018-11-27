#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step10_all_target_drug_indication_MOA.txt";
my $fo1 = "./step11_unique_indication.txt"; #unique_indiccation的信息。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;
#print "Drug_indication|Indication_class\n";


my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)  
{
   chomp;
   unless(/^Drug_chembl_id|Drug_claim_primary_name/){
       my @f = split/\t/;
       my $Drug_indication_or_Indication_class = $f[19];
       my $k3 = $Drug_indication_or_Indication_class ;
       unless(exists $hash3{$k3}){
           print $O1 "$k3\n";
           $hash3{$k3} = 1;
       }
   }
}


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
