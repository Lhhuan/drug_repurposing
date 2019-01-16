#看../../test_data/output/09_filter_test_data_for_logistic_regression.txt 中的drug cancer pair是否和./output/11_prediction_and_icgc_result.txt
#中的drug cancer pair有重叠，得有重叠的文件./output/14_paper_drug_cancer_overlap_with_Positive_sample.txt,得没有重叠的文件./output/14_paper_drug_cancer_out_Positive_sample.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;

my $f1 = "../../test_data/output/09_filter_test_data_for_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/11_prediction_and_icgc_result.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/14_paper_drug_cancer_overlap_with_Positive_sample.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/14_paper_drug_cancer_out_Positive_sample.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
# my $f2 = "./output/11_prediction_and_icgc_result_top0.1.txt";
# open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
# my $fo1 = "./output/14_paper_drug_cancer_overlap_with_Positive_sample_top0.1.txt";
# open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_in_paper\toncotree_id\toncotree_id_type\tpaper_sample_name\tpredict_value\tvalue_in_paper";
print $O1 "$header\n";
print $O2 "$header\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^cancer_oncotree_id_type/){
        my @f =split/\t/;
        my $cancer_oncotree_id_type = $f[0];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_id =$f[2];
        my $drug_repurposing = $f[-1];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        if ($drug_repurposing =~/1/){
            $hash1{$k}=1;
        }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $oncotree_id = $f[2];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_id";
        if (exists $hash1{$k}){
            print $O1 "$_\n";
        }
        else{
            print $O2 "$_\n";
        }
    }
}