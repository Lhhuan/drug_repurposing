#统计./output/01_filter_sample_drug_info.txt中药物的fda 和indication 是否为cancer,得./output/02_statistics_drug_fda_approval_and_indication_cancer.txt,然后为其添加Drug_claim_primary_name，
#得./output/02_statistics_drug_fda_approval_and_indication_cancer_final.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;


my $f1 ="./output/01_filter_sample_drug_info.txt";
my $fo1 ="./output/02_statistics_drug_fda_approval_and_indication_cancer.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash5,%hash6);
my $header = "Drug_chembl_id_Drug_claim_primary_name\trepo_cancer_id\trepurposing\tindication_is_cancer\tMax_phase";
print $O1 "$header\n";
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name = $f[1];
        my $k = $Drug_chembl_id_Drug_claim_primary_name;
        my $Max_phase = $f[2];
        my $indication_OncoTree_IDs_detail = $f[12];
        my $indication_OncoTree_main_ID = $f[14];
        my $repo_cancer_id = $f[15];
        my $repo_type = $f[17];
        my $v1 = "$repo_cancer_id\t$repo_type";
        push @{$hash1{$k}},$v1;
        unless ($indication_OncoTree_main_ID=~/NA/){
            push @{$hash2{$k}},$indication_OncoTree_main_ID;
        }
        if ($Max_phase =~/\d+/){ #这个文件里的所以drug的max 为：0,1,2,3,4，unknown\
            push @{$hash3{$k}},$Max_phase;
        }
        push @{$hash6{$k}},$Drug_claim_primary_name;
    }
}

foreach my $drug(sort keys %hash1){
    my @infos = @{$hash1{$drug}};
    my %hash4;
    @infos = grep { ++$hash4{$_} < 2 } @infos;
    foreach my $info(@infos){
        my @output =();
        push @output,$drug;
        push @output,$info;
        if (exists $hash2{$drug}){
            my $cancer = "Y";
            push @output,$cancer;
        }
        else{
            my $cancer = "N";
            push @output,$cancer;
        }
        if(exists $hash3{$drug}){
            my @Max_phase_s =@{$hash3{$drug}};
            my $Max_phase= max @Max_phase_s;
            push @output,$Max_phase;
        }
        else{
            my $Max_phase= "unknown";
            push @output,$Max_phase;
        }
        my $final_output = join("\t",@output);
        unless(exists $hash5{$final_output}){
            $hash5{$final_output} =1;
            print $O1 "$final_output\n";
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

my $f3 ="./output/02_statistics_drug_fda_approval_and_indication_cancer.txt";
my $fo4 ="./output/02_statistics_drug_fda_approval_and_indication_cancer_final.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";

print $O4 "Drug_claim_primary_name\t$header\n";
while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        if (exists $hash6{$Drug_chembl_id_Drug_claim_primary_name}){
            my @Drug_claim_primary_names = @{$hash6{$Drug_chembl_id_Drug_claim_primary_name}};
            my %hash7;
            @Drug_claim_primary_names = grep { ++$hash7{$_} < 2 } @Drug_claim_primary_names;
            foreach my $Drug_claim_primary_name(@Drug_claim_primary_names){
                my $output = "$Drug_claim_primary_name\t$_";
                print $O4 "$output\n";
            }
        }
    }
}