#统计cancer drug indication的分类， 用./output/cancer_drug_type.txt和./output/21_all_drug_infos.txt统计每个cancer indication 中的药物个数。得./output/indication_contains_drug_number.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;

my $f1 ="./output/cancer_drug_type.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./output/21_all_drug_infos.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/indication_contains_drug_number.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Indication_oncotree_ID\tDrug_number\n";

my (%hash1,%hash2);

while(<$I1>)
{
    chomp;
    my @f =split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        $hash1{$Drug_chembl_id_Drug_claim_primary_name} =1;
    }
}

while(<$I2>)
{
    chomp;
    my @f =split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $indication_OncoTree_main_ID = $f[-1];
        if(exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){
            unless($indication_OncoTree_main_ID =~/NA|Other|Unmatch/){ #除掉other后，药物可能比统计的要少
                my @ts = split/\;/,$indication_OncoTree_main_ID;
                foreach my $t(@ts){
                    # print "$t\n";
                    push @{$hash2{$t}},$Drug_chembl_id_Drug_claim_primary_name;
                }
            }
        }
    }
}

foreach my $oncotree_main_term(sort keys %hash2){
    my @drugs = @{$hash2{$oncotree_main_term}};
    my %hash3;
    @drugs = grep { ++$hash3{$_} < 2 } @drugs ; ##数组内去重
    my $num = @drugs;
    print $O1 "$oncotree_main_term\t$num\n";
}