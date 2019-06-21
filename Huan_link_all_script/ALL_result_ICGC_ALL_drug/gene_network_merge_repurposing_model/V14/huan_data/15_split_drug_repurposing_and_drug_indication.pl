# 把./output/14_merge_oncotree_main_detail_term.txt 中的indication和drug repurposing 分开，并把>=0.9的打上lable,得./output/15_drug_repurposing_recall_indication.txt 和./output/15_drug_potential_repurposing.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./output/14_merge_oncotree_main_detail_term.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/15_drug_repurposing_recall_indication.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./output/15_drug_potential_repurposing.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 ="./output/15_drug_potential_repurposing_more_than_0.999_list_example.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my $header= "Drug_chembl_id_Drug_claim_primary_name\tDrug_claim_primary_name";
$header = "$header\tcancer_oncotree_detail_ID\tcancer_oncotree_main_ID\tcancer_oncotree_detail_term\tcancer_oncotree_main_term";
$header = "$header\tcancer_oncotree_id_type\tpredict\tpredict_value\tDrug_indication_Indication_class\tindication_OncoTree_detail_ID\tindication_OncoTree_main_ID\tcancer_lable\tscore_lable";
print $O1 "$header\n";
print $O2 "$header\tpairs\n";
print $O3 "Drug_chembl_id_Drug_claim_primary_name\tDrug_claim_primary_name\tcancer_oncotree_detail_ID\tcancer_oncotree_main_ID\tcancer_oncotree_detail_term\tcancer_oncotree_main_term\tpredict_value\n";

my (%hash1,%hash2,%hash3,%hash4,%hash7,%hash9);
while(<$I1>)
{
    chomp;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my @f= split /\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name= $f[1];
        my $cancer_oncotree_detail_ID = $f[2];
        my $cancer_oncotree_main_ID = $f[3];
        my $cancer_oncotree_detail_term= $f[4];
        my $cancer_oncotree_main_term = $f[5];
        my $predict_value = $f[8];
        my $pair = "$Drug_chembl_id_Drug_claim_primary_name\,$cancer_oncotree_detail_ID";
        my $cancer_lable =$f[-1];
        if($cancer_lable=~/indication/){ #indication
            if ($predict_value>=0.9){
                print $O1 "$_\t\>\=0.9\n";
            }
            else{
                print $O1 "$_\t\<0.9\n";
            }
        }
        else{
            if ($predict_value>=0.999){ #repo
                print $O2 "$_\t\>\=0.999\t$pair\n";
                $Drug_claim_primary_name =~s/\|/\|; /g;
                print $O3 "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_claim_primary_name\t$cancer_oncotree_detail_ID\t$cancer_oncotree_main_ID\t$cancer_oncotree_detail_term\t$cancer_oncotree_main_term\t$predict_value\n";
                
            }
            else{
                print $O2 "$_\t\<0.999\t$pair\n";
            }
        }
    }
}




