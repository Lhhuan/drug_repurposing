#检查"/f/mulinlab/huan/All_result_ICGC/DGIdb_all_target_drug_indication.txt"比"/f/mulinlab/huan/All_result_ICGC/drug_moa_before/All_result_ICGC/DGIdb_all_target_drug_indication.txt"多的列
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/DGIdb_all_target_drug_indication.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="/f/mulinlab/huan/All_result_ICGC/drug_moa_before/All_result_ICGC/DGIdb_all_target_drug_indication.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./new_add_new_indication.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
# my $fo2 ="./dgidb_unique_indication.txt"; 
# open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";



my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     $hash1{$_}=1;
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    $hash2{$_}=1;
}

foreach my $k (sort keys %hash1){
    unless(exists $hash2{$k}){
        print $O1 "$k\n";
    }
}