#统计./output/04_sample_in_paper_top_repurposing_value.txt 中predict_value >0.9的每个drug推荐的sample个数，得./output/05_count_drug_number_in_sample.txt
## 得 包含drug sample数目的drug cancer sample info得 ./output/05_count_drug_number_in_sample_info.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/04_sample_in_paper_top_repurposing_value.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 = "./output/05_count_drug_number_in_sample.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/05_count_drug_number_in_sample_info.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my %hash1; 
print $O1 "Drug_chembl_id_Drug_claim_primary_name\tnumber\n";
print $O2 "Drug_chembl_id_Drug_claim_primary_name\tnumber\toncotree_id\toncotree_id_type\tpaper_sample_name\tpredict_value\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $oncotree_id = $f[1];
        my $oncotree_id_type =$f[2];
        my $paper_sample_name = $f[3];
        my $predict_value =$f[-1];
        #if ($predict_value>0.5){ #只统计predict_value>0.5
        if ($predict_value>=0.9){ #只统计predict_value>0.5
            my $v= "$oncotree_id\t$oncotree_id_type\t$paper_sample_name\t$predict_value";
            push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$v;
        }
    }
}

foreach my $drug(sort keys %hash1){
    my @vs =@{$hash1{$drug}};
    my %hash2;
    @vs = grep { ++$hash2{$_} < 2 } @vs;
    my $number = @vs;
    my $output = "$drug\t$number";
    print $O1 "$output\n";
    foreach my $v(@vs){
        print $O2 "$output\t$v\n";
    }
}


