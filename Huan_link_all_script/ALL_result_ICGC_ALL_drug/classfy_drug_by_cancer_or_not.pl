#用./output/all_drug_infos_score_type.txt把cancer drug和非cancer drug 分开，得cancer drug文件cancer_drug_type.txt, 得非cancer drug文件，./output/noncancer_drug_type.txt
#记录cancer 和非cancer drug每种drug type的cancer数目，分别得文件./output/cancer_drug_type_number.txt， ./output/noncancer_drug_type_number.txt #共有cancer drug 1603个，非cancer drug 4345个
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/all_drug_infos_score_type.txt";
my $fo1 ="./output/cancer_drug_type.txt";
my $fo2 ="./output/noncancer_drug_type.txt";
my $fo3 ="./output/cancer_drug_type_number.txt"; 
my $fo4 ="./output/noncancer_drug_type_number.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";

my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_type";
print $O1 "$header\n";
print $O2 "$header\n";
my $out1 = "drug_type\tdrug_number";
print $O3 "$out1\n";
print $O4 "$out1\n";
my (%hash1, %hash2);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $indication_OncoTree_main_ID = $f[-3];
        my $drug_type = $f[-1];
        $hash1{$Drug_chembl_id_Drug_claim_primary_name}=$drug_type;
        unless ($indication_OncoTree_main_ID=~/\bNA\b/){ #indication 不是cancer的不能进入循环，如果一个药物的所有indication都没有进入循环，那这个药物就是非cancer 的药物
            push @{$hash2{$Drug_chembl_id_Drug_claim_primary_name}},$indication_OncoTree_main_ID;
        }
    }
}

foreach my $drug (sort keys %hash1){
    my $drug_type =$hash1{$drug};
    if(exists $hash2{$drug}){ #cancer drug
        print $O1 "$drug\t$drug_type\n";
    }
    else{#non-cancer drug
        print $O2 "$drug\t$drug_type\n";
    }
}

close($O1);
close($O2);

my $f2 ="./output/cancer_drug_type.txt";
my $f3 ="./output/noncancer_drug_type.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";

my (%hash3,%hash4);
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug_type = $f[-1];
        push @{$hash3{$drug_type}},$Drug_chembl_id_Drug_claim_primary_name;
    }
}


while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug_type = $f[-1];
        push @{$hash4{$drug_type}},$Drug_chembl_id_Drug_claim_primary_name;
    }
}

foreach my $type(sort keys %hash3){ #cancer
    my @drugs = @{$hash3{$type}};
    $type =~s/biotech/Biotech/g;
    $type =~s/small/Small/g;
    $type =~s/unclassified/Unclassified/g;
    my $drug_number = @drugs;
    print $O3 "$type\t$drug_number\n";
}

foreach my $type(sort keys %hash4){ #noncancer
    my @drugs = @{$hash4{$type}};
    $type =~s/biotech/Biotech/g;
    $type =~s/small/Small/g;
    $type =~s/unclassified/Unclassified/g;
    my $drug_number = @drugs;
    print $O4 "$type\t$drug_number\n";
}