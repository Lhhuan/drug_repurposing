#将./output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt中的../test_data/output/11_all_training_dataset.txt筛选出来
#得./output/09_training_dataset_repurposing_data.txt ,得没有训练集的预测数据文件./output/09_out_of_training_dataset_repurposing_data.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;



# my $f1 = "./1234.txt";
my $f1 = "../test_data/output/11_all_training_dataset.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/09_training_dataset_repurposing_data.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/09_out_of_training_dataset_repurposing_data.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    my $Drug_chembl_id_Drug_claim_primary_name =$f[1];
    my $cancer_oncotree_id =$f[2];
    if (/^cancer_oncotree_id_type/){
        print $O1 "$_\n";
    }
    else{
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        $hash1{$k}=1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    my $Drug_chembl_id_Drug_claim_primary_name =$f[0];
    my $cancer_oncotree_id =$f[1];
    if (/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O2 "$_\n";
    }
    else{
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        if (exists $hash1{$k}){ #training dataset
            print $O1 "$_\n";
        }
        else{
            print $O2 "$_\n";
        }
    }
}