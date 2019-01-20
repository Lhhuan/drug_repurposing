#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f4 ="./output/09_filter_test_data_for_logistic_regression_re.txt";
my $fo3 ="./output/09_filter_test_data_for_logistic_regression.txt";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    if (/^cancer_oncotree_id_type/){
        print $O3 "$_\n";
    }
    else{
        my $cancer_oncotree_id_type = $f[0];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_id = $f[2];
        my $k = "$cancer_oncotree_id_type\t$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        push @{$hash5{$k}},$_;
    }
}

foreach my $k(sort keys %hash5){
    my @vs = @{$hash5{$k}};
    my $num = @vs;
    unless($num>1){
        foreach my $v(@vs){
            print $O3 "$v\n";
        }
    }
}