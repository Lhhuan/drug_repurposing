#将 ./output/17_drug_cancer_pairs_actionable_number.txt 和./output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt merge在一起，
#得./output/18_actionable_number_and_prediction_value.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/17_drug_cancer_pairs_actionable_number.txt";
my $f2 = "./output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt";
my $fo1 = "./output/18_actionable_number_and_prediction_value.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2);


print $O1 "Drug_chembl_id_Drug_claim_primary_name\toncotree_ID\toncotree_id_type\tpredict_value\tactionable_mutation_number\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id_Drug_claim_primary_name/){
       my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
       my $oncotree_ID =$f[1];
       my $oncotree_id_type = $f[2];
       my $actionable_mutation_number = $f[3];
       my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID\t$oncotree_id_type";
       $hash1{$k}=$actionable_mutation_number;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $cancer_oncotree_id = $f[1];
        my $cancer_oncotree_id_type =$f[2];
        my $predict_value = $f[-1];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id\t$cancer_oncotree_id_type";
        if (exists $hash1{$k}){
            my $actionable_mutation_number = $hash1{$k};
            my $output = "$k\t$predict_value\t$actionable_mutation_number";
            print $O1 "$output\n";
        }
        else{
            print $O1 "$k\t$predict_value\t0\n";
        }
    }
}
