# 把./output/08_merge_top_number_drug_sample_mutation_hgvsg.txt和 /f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt
#中的Drug_claim_primary_name merge 到一起，得./output/081_final_top_number_drug_sample_mutation_hgvsg.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt";
my $f2 ="./output/08_merge_top_number_drug_sample_mutation_hgvsg.txt";
my $fo1 ="./output/081_final_top_number_drug_sample_mutation_hgvsg.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0];
        my $Drug_claim_primary_name = $f[4];
        push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$Drug_claim_primary_name;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "Drug_claim_primary_name\t$_\n";
    }
    else{
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0];
        my $Drug= $Drug_chembl_id_Drug_claim_primary_name;
        if (exists $hash1{$Drug}){
            my @Drug_claim_primary_names = @{$hash1{$Drug}};
            my %hash5;
            @Drug_claim_primary_names = grep { ++$hash5{$_} < 2 } @Drug_claim_primary_names;
            foreach my $Drug_claim_primary_name(@Drug_claim_primary_names){
                my $output = "$Drug_claim_primary_name\t$_";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 " $output\n";
                }
                
            }
        }
        else{ #正确的情况下，这里else没有东西输出
            print STDERR "$Drug\n"; 
        }
        
    }
}

