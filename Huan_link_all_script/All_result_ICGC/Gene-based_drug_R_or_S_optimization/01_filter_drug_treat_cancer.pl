# 把"/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_all_sorted_drug_target_repo_symbol_entrez_num.txt"中indication是cancer的整行过滤出来，得01_filter_drug_treat_cancer.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_all_sorted_drug_target_repo_symbol_entrez_num.txt";
my $fo1 ="./01_filter_drug_treat_cancer.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "drug_name\tdrug_symbol\tdrug_entrez\tdrug_entrez_network_id\trepo\trepo_symbol\trepo_entrez\trepo_entrez_network_id\n"; 

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug_name/){
        my $repo = $f[4];
        if ($repo=~/cancer|oma|tumor|leukemia/){
            print $O1 "$_\n";
        }
     }
}

