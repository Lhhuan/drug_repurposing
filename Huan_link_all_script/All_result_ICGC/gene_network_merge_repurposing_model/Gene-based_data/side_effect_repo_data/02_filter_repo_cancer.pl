#把"/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/09_all_sorted_drug_target_repo_symbol_entrez.txt"中repo为cancer的筛选出来，得02_repo_cancer.txt,得02_unique_repo_cancer.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/09_all_sorted_drug_target_repo_symbol_entrez.txt";
my $fo1 ="./02_repo_cancer.txt"; 
my $fo2 ="./02_unique_repo_cancer.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";


my %hash1;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $repo = $f[3];
    if(/^drug_name/){
        print $O1 "$_\n";
    }
    else{
        if ($repo =~/cancer|tumor|oma|Neoplasm|Neoplasia/i){
            print $O1 "$_\n";
            unless(exists $hash1{$repo}){
                $hash1{$repo}=1;
                print $O2 "$repo\n";
            }
        }
    }

}

