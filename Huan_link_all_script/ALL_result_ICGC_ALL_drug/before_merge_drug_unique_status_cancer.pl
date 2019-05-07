 #将./output/all_drug_unique_status.txt 和./output/cancer_drug_type.txt， ./output/noncancer_drug_type.txt merge 到一起，得cancer drug 的status 文件./output/cancer_drug_type_status.txt
#得non-cancer 的status 文件 ./output/non-cancer_drug_type_status.txt.
#记录cancer 和非cancer drug每种drug type的cancer数目，分别得文件./output/cancer_drug_status_number.txt， ./output/noncancer_drug_status_number.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/all_drug_unique_status.txt";
my $f2 ="./output/cancer_drug_type.txt";
my $f3 ="./output/noncancer_drug_type.txt";
my $fo1 ="./output/cancer_drug_type_status.txt";
my $fo2 ="./output/noncancer_drug_type_status.txt";
my $fo3 ="./output/cancer_drug_status_number.txt"; 
my $fo4 ="./output/noncancer_drug_status_number.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";

my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_type\tmax_status";
print $O1 "$header\n";
print $O2 "$header\n";
my $out1 = "drug_status\tdrug_number";
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
        my $Max_phase = $f[1];
        $Max_phase=~s/unknown/Unknown/g;
        $Max_phase=~s/NA/unknown/g;
        $Max_phase=~s/Phase0/Phase 0/g;
        $Max_phase=~s/Phase1/Phase 1/g;
        $Max_phase=~s/Phase2/Phase 2/g;
        $Max_phase=~s/Phase3/Phase 3/g;
        $Max_phase=~s/Phase4/Phase 4/g;
        $Max_phase=~s/Approved/FDA approved/g;
        $Max_phase =~ s/Launched/FDA approved/g;
        my $First_approval = $f[2];
        $hash1{$Drug_chembl_id_Drug_claim_primary_name}=$Max_phase;
    }
}


my (%hash3,%hash4);
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug_type = $f[-1];
        if (exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){
            my $status = $hash1{$Drug_chembl_id_Drug_claim_primary_name};
            print $O1 "$_\t$status\n";
            push@{$hash3{$status}},$Drug_chembl_id_Drug_claim_primary_name;
        }
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
        if (exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){
            my $status = $hash1{$Drug_chembl_id_Drug_claim_primary_name};
            print $O2 "$_\t$status\n";
            push@{$hash4{$status}},$Drug_chembl_id_Drug_claim_primary_name;
        }
    }
}

foreach my $type(sort keys %hash3){ #cancer
    my @drugs = @{$hash3{$type}};
    my $drug_number = @drugs;
    print $O3 "$type\t$drug_number\n";
}

foreach my $type(sort keys %hash4){ #noncancer
    my @drugs = @{$hash4{$type}};
    my $drug_number = @drugs;
    print $O4 "$type\t$drug_number\n";
}