# 统计drug target 个数分布，用./output/21_all_drug_infos.txt统计每个drug 的target数目，得./output/drug_target_number.txt,#统计drug target数目相同的drug 有几个
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;

my $f1 ="./output/21_all_drug_infos.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/drug_target_number.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Drug_chembl_id_Drug_claim_primary_name\ttarget_number\n";

my $fo2 ="./output/drug_number_of_target_number.txt"; #统计drug target数目相同的drug 有几个
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O2 "Target_number\tDrug_number\n";

my (%hash1,%hash2);


while(<$I1>)
{
    chomp;
    my @f =split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $ENSG_ID = $f[14];
        # print "$Drug_chembl_id_Drug_claim_primary_name\t$ENSG_ID\n";
        push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$ENSG_ID;
    }
}

foreach my $drug (sort keys %hash1){
    my @targets = @{$hash1{$drug}};
    my %hash3;
    @targets = grep { ++$hash3{$_} < 2 } @targets ; ##数组内去重
    my $drug_target_number =@targets;
    print $O1 "$drug\t$drug_target_number\n";  
    push @{$hash2{$drug_target_number}},$drug; #统计drug target数目相同的drug 有几个
}



foreach my $drug_target_number(sort keys %hash2){
    my @drugs = @{$hash2{$drug_target_number}};
    my %hash4;
    @drugs = grep { ++$hash4{$_} < 2 } @drugs ; ##数组内去重
    my $num = @drugs;
    print $O2 "$drug_target_number\t$num\n";
}