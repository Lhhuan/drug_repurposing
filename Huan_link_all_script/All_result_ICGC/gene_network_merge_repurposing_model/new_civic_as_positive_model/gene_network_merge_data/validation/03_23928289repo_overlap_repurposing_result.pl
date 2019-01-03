#看../huan_data/output/09_repurposing_Drug_claim_primary_name.txt 中除去在训练集../test_data/output/09_filter_test_data_for_logistic_regression.txt 中出现的drug cancer pair,与./output/02_23928289_repo_cancer.txt 的overlap 
#得./output/03_23928289repo_overlap_repurposing_result.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../test_data/output/09_filter_test_data_for_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "../huan_data/output/09_repurposing_Drug_claim_primary_name.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 = "./output/02_23928289_repo_cancer.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 = "./output/03_23928289repo_overlap_repurposing_result.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);
print $O1 "Drug_claim_primary_name\tcancer_oncotree_id\toncotree_main_term\tDrug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_id_type\tpredict_value\n";


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^cancer_oncotree_id_type/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_id =$f[2];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        $hash1{$k}=1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_claim_primary_name/){
        my @f =split/\t/;
        my $Drug_claim_primary_name = $f[0];
        $Drug_claim_primary_name =lc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~s/\&/+/g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\//_/g; 
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_id =$f[2];
        my $cancer_oncotree_id_type =$f[3];
        my $predict_value =$f[-1];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        my $k1 = "$Drug_claim_primary_name\t$cancer_oncotree_id";
        my $v = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id_type\t$predict_value";
        unless(exists $hash1{$k}){
            $hash2{$k1}=$v;
        }
    }
}


while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_claim_primary_name/){
        my @f =split/\t/;
        my $Drug_claim_primary_name = $f[0];
        $Drug_claim_primary_name =lc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~s/\&/+/g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\//_/g; 
        my $oncotree_main_term = $f[2];
        my $oncotree_detail_ID = $f[3];
        my $oncotree_main_ID = $f[5];
        my $k1 = "$Drug_claim_primary_name\t$oncotree_detail_ID";
        my $k2 = "$Drug_claim_primary_name\t$oncotree_main_ID";
        if (exists $hash2{$k1}){
            my $v= $hash2{$k1};
            my $output = "$k1\t$oncotree_main_term\t$v";
            print $O1 "$output\n";
        }
        else{
            if (exists $hash2{$k2}){
                my $v= $hash2{$k2};
                my $output = "$k2\t$oncotree_main_term\t$v";
                print $O1 "$output\n";
            }
        }
    }
}