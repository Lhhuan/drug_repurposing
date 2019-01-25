#筛选./output/02_merge_mtctscan_all_sensitivity_oncotree.txt 在../../test_data/output/09_media_filter_test_data_for_logistic_regression.txt中没有出现的，
#oncotree 非 NA的drug cancer 信息。得./output/03_fllter_mtctscan_cancer_gene_out_test_data.txt,
#得只有cancer 和drug的信息文件./output/03_fllter_mtctscan_cancer_gene_out_test_drug_cancer.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my $f1 ="../../test_data/output/09_media_filter_test_data_for_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./output/02_merge_mtctscan_all_sensitivity_oncotree.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/03_fllter_mtctscan_cancer_gene_out_test_data.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./output/03_fllter_mtctscan_cancer_gene_out_test_drug_cancer.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my (%hash1, %hash2);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug_claim_primary_name =$f[0];
        my $cancer_oncotree_id_type = $f[1];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[2];
        my $cancer_oncotree_id = $f[3];
        $Drug_claim_primary_name =uc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~s/\(.*?$//g;
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~s/\&/+/g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\.//g;
        $Drug_claim_primary_name =~s/\-//g;
        my $k = "$Drug_claim_primary_name\t$cancer_oncotree_id";
        $hash1{$k}=1;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if (/^drug_name/){
        print $O1 "$_\n";
    }
    else{
        my $drug_name= $f[0];
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_ID = $f[-1];
        my $Drug_claim_primary_name = $drug_name;
        $Drug_claim_primary_name =uc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~s/\(.*?$//g;
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~s/\&/+/g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\.//g;
        $Drug_claim_primary_name =~s/\-//g;  
        my $k1 = "$Drug_claim_primary_name\t$oncotree_detail_ID";
        my $k2 = "$Drug_claim_primary_name\t$oncotree_main_ID";    
        my $output2 = "$drug_name\t$oncotree_detail_ID\t$oncotree_main_ID";
        unless($oncotree_main_ID =~/NA/){ #oncotree_ID 是NA的数据被筛选掉
            unless (exists $hash1{$k1}){
                unless(exists $hash1{$k2}){
                    print $O1 "$_\n";
                    unless(exists $hash2{$output2}){
                        $hash2{$output2} =1;
                        print $O2 "$output2\n";
                    }
                }
            }
        }
    }
}
