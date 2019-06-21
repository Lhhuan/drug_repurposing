#用./output/all_drug_infos_score_type.txt把no-indication drug和 indication drug分开。indication drug又分为 cancer drug和非cancer drug ，得drug indication type文件./output/drug_indication_type.txt 
#得cancer drug文件./output/cancer_drug_type.txt, 得非cancer drug文件，./output/noncancer_drug_type.txt，得no-indication drug 文件./output/noncancer_drug_type.txt
#记录cancer 、非cancer drug和no indication 每种drug type的cancer数目，分别得文件./output/cancer_drug_type_number.txt， ./output/noncancer_drug_type_number.txt #共有cancer drug 2759个，非cancer drug 4037个 
#./output/no_indication_drug_number.txt #没有indication的drug 6255个。得三种药物数目统计文件./output/three_type_drug_type_number.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/all_drug_infos_score_type.txt";
my $fo1 ="./output/cancer_drug_type.txt";
my $fo2 ="./output/noncancer_drug_type.txt";
my $fo3 ="./output/no_indication_drug.txt";
my $fo4 ="./output/cancer_drug_type_number.txt"; 
my $fo5 ="./output/noncancer_drug_type_number.txt";
my $fo6 ="./output/no_indication_drug_type_number.txt";
my $fo7 ="./output/three_type_drug_type_number.txt";
my $fo8 ="./output/drug_indication_type.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
open my $O5, '>', $fo5 or die "$0 : failed to open output file '$fo5' : $!\n";
open my $O6, '>', $fo6 or die "$0 : failed to open output file '$fo6' : $!\n";
open my $O7, '>', $fo7 or die "$0 : failed to open output file '$fo7' : $!\n";
open my $O8, '>', $fo8 or die "$0 : failed to open output file '$fo8' : $!\n";

my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_type";
print $O1 "$header\n";
print $O2 "$header\n";
print $O3 "$header\n";
my $out1 = "drug_type\tdrug_number";
print $O4 "$out1\n";
print $O5 "$out1\n";
print $O6 "$out1\n";
print $O8 "Drug_chembl_id_Drug_claim_primary_name\tdrug_type\tindication_type\n";
my (%hash1, %hash2,%hash3);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_indication_Indication_class = $f[13];
        my $indication_OncoTree_main_ID = $f[-3];
        my $drug_type = $f[-1];
        $hash1{$Drug_chembl_id_Drug_claim_primary_name}=$drug_type;
        unless($Drug_indication_Indication_class =~/\bNA\b/){ #Drug_indication_Indication_class 是NA的不能进入循环，如果一个药物的所有Drug_indication_Indication_class都没有进入循环，那这个药物就是没有indication 的药物
                $hash2{$Drug_chembl_id_Drug_claim_primary_name}=1;
            unless ($indication_OncoTree_main_ID=~/\bNA\b/){ #indication 不是cancer的不能进入循环，如果一个药物的所有indication都没有进入循环，那这个药物就是非cancer 的药物
                push @{$hash3{$Drug_chembl_id_Drug_claim_primary_name}},$indication_OncoTree_main_ID;
            }
        }
    }
}

foreach my $drug (sort keys %hash1){
    my $drug_type =$hash1{$drug};
    if(exists $hash3{$drug}){ #cancer drug
        print $O1 "$drug\t$drug_type\n";
        print $O8 "$drug\t$drug_type\tCancer_drug\n";
    }
    elsif(exists $hash2{$drug}){ #non-cancer drug
        print $O2 "$drug\t$drug_type\n";
        print $O8 "$drug\t$drug_type\tNon-cancer_drug\n";
    }
    else{# no indication drug 
        print $O3 "$drug\t$drug_type\n";
        print $O8 "$drug\t$drug_type\tNo_indication_drug\n";
    }
}

close($O1);
close($O2);
close($O3);

my $f2 ="./output/cancer_drug_type.txt";
my $f3 ="./output/noncancer_drug_type.txt";
my $f4 ="./output/no_indication_drug.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
my (%hash4,%hash5,%hash6,%hash8,%hash9,%hash10);
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        $hash8{$Drug_chembl_id_Drug_claim_primary_name}=1;
        my $drug_type = $f[-1];
        push @{$hash4{$drug_type}},$Drug_chembl_id_Drug_claim_primary_name;
    }
}


while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        $hash9{$Drug_chembl_id_Drug_claim_primary_name}=1;
        my $drug_type = $f[-1];
        push @{$hash5{$drug_type}},$Drug_chembl_id_Drug_claim_primary_name;
    }
}

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        $hash10{$Drug_chembl_id_Drug_claim_primary_name}=1;
        my $drug_type = $f[-1];
        push @{$hash6{$drug_type}},$Drug_chembl_id_Drug_claim_primary_name;
    }
}

foreach my $type(sort keys %hash4){ #cancer
    my @drugs = @{$hash4{$type}};
    $type =~s/biotech/Biotech/g;
    $type =~s/small/Small/g;
    $type =~s/unclassified/Unclassified/g;
    my $drug_number = @drugs;
    print $O4 "$type\t$drug_number\n";
}

foreach my $type(sort keys %hash5){ #noncancer
    my @drugs = @{$hash5{$type}};
    $type =~s/biotech/Biotech/g;
    $type =~s/small/Small/g;
    $type =~s/unclassified/Unclassified/g;
    my $drug_number = @drugs;
    print $O5 "$type\t$drug_number\n";
}

foreach my $type(sort keys %hash6){ #noncancer
    my @drugs = @{$hash6{$type}};
    $type =~s/biotech/Biotech/g;
    $type =~s/small/Small/g;
    $type =~s/unclassified/Unclassified/g;
    my $drug_number = @drugs;
    print $O6 "$type\t$drug_number\n";
}

my $length1 = keys %hash8;  #统计数组长度
my $length2 = keys %hash9;
my $length3 = keys %hash10;

print $O7 "Drug_number\tDrug_type\n";
print $O7 "$length1\tCancer drug\n";
print $O7 "$length2\tNon-cancer drug\n";
print $O7 "$length3\tNo indication drug\n";