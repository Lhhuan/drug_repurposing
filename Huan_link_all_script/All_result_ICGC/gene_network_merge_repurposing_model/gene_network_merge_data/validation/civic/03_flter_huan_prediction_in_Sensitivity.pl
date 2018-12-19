#查找在./output/02_Sensitivity_clinical_significance_oncotree.txt中出现的../huan_data/output/10_final_full_drug_repurposing_success.txt ，
#得./overlap_with_huan_data/03_huan_prediction_data_overlap_Sensitivity.txt
#得unique的overlap drug cancer pair 是./overlap_with_huan_data/03_unique_huan_prediction_data_overlap_Sensitivity.txt，
##huan_data 中可以与./output/02_Sensitivity_clinical_significance_oncotree.txt中有overlap的drug文件"./overlap_with_huan_data/03_huan_prediction_sensitivity_drug.txt"
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/02_Sensitivity_clinical_significance_oncotree.txt";
my $f2 ="../../huan_data/output/10_final_full_drug_repurposing_success.txt";
my $fo1 ="./overlap_with_huan_data/03_huan_prediction_data_overlap_Sensitivity.txt";
my $fo2 ="./overlap_with_huan_data/03_unique_huan_prediction_data_overlap_Sensitivity.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 ="./overlap_with_huan_data/03_huan_prediction_sensitivity_drug.txt"; #huan_data 中可以与./output/02_Sensitivity_clinical_significance_oncotree.txt中有overlap的drug
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Drug_claim_primary_name\tDrug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\tpredict_value\tdrug_Max_phase\tdrug_First_approval\n";
print $O2 "Drug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\tpredict_value\tdrug_Max_phase\tdrug_First_approval\n";
print $O3 "Drug_claim_primary_name\tDrug_chembl_id_Drug_claim_primary_name\n"; 

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^disease/){
        my $oncotree_main_tissue_ID = $f[0];
        my $drug =$f[1];
        $drug =~s/\s+//g;#为了建文件夹方便，把空格替换成_
        $drug =~s/"//g;#后面也是为了建文件夹方便
        $drug =~s/\(//g;
        $drug =~s/\)//g;
        $drug =~s/\//_/g;
        $drug =~s/\&/+/g; #把&替换+
        $drug =~s/-/_/g;
        $drug =~s/,/+/g;
        $drug =~s/\[//g;
        $drug =~s/\]//g;
        $drug = lc($drug);
        my $k = "$drug\t$oncotree_main_tissue_ID";
        $hash1{$k}=1;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^Drug_claim_primary_name/){
        my $Drug_claim_primary_name = $f[0];
        my $Drug_chembl_id_Drug_claim_primary_name =$f[1];
        my $cancer_oncotree_main_id = $f[2];
        my $predict_value = $f[-3];
        my $drug_Max_phase = $f[-2];
        my $drug_First_approval = $f[-1];
        my $output1 = "$Drug_claim_primary_name\t$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_main_id\t$predict_value\t$drug_Max_phase\t$drug_First_approval";
        my $output2 = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_main_id\t$predict_value\t$drug_Max_phase\t$drug_First_approval";
        my $output3 = "$Drug_claim_primary_name\t$Drug_chembl_id_Drug_claim_primary_name";
        $Drug_claim_primary_name =~s/\s+//g;#为了建文件夹方便，把空格替换成_
        $Drug_claim_primary_name =~s/"//g;#后面也是为了建文件夹方便
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\&/+/g; #把&替换+
        $Drug_claim_primary_name =~s/-/_/g;
        $Drug_claim_primary_name =~s/,/+/g;
        $Drug_claim_primary_name =~s/\[//g;
        $Drug_claim_primary_name =~s/\]//g;
        $Drug_claim_primary_name = lc($Drug_claim_primary_name);
        my $k = "$Drug_claim_primary_name\t$cancer_oncotree_main_id";
        if (exists $hash1{$k}){
            unless (exists $hash2{$output1}){
                $hash2{$output1}=1;
                print $O1 "$output1\n";
            }
            unless(exists $hash3{$output2}){
                $hash3{$output2}=1;
                print $O2 "$output2\n";
            }
            unless (exists $hash4{$output3}){
                $hash4{$output3}=1;
                print $O3 "$output3\n";
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n"; #关闭文件句柄