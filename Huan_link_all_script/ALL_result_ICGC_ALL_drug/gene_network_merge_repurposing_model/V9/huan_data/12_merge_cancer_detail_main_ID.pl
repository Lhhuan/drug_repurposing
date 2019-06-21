#用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中的detail id 和 main id
#和./output/11_drug_unique_status_infos.txt(cancer) merge到一起，得./output/12_merge_cancer_detail_main_ID.txt #原来的$cancer_oncotree_id变成了$indication_OncoTree_detail_ID
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./output/11_merge_drug_indication.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/12_merge_cancer_detail_main_ID.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header= "Drug_chembl_id_Drug_claim_primary_name\tDrug_claim_primary_name";
$header = "$header\tcancer_oncotree_detail_ID\tcancer_oncotree_main_ID";
$header = "$header\tcancer_oncotree_id_type\tpredict\tpredict_value\tDrug_indication_Indication_class\tindication_OncoTree_detail_ID\tindication_OncoTree_main_ID";
print $O1 "$header\n";



my (%hash1,%hash2,%hash3,%hash4,%hash7,%hash9);
while(<$I1>)
{
    chomp;
    unless(/^project/){
        my @f= split /\t/;
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_ID = $f[-1];
        $hash1{$oncotree_detail_ID} =$oncotree_main_ID;
    }
}


while(<$I2>)
{
    chomp;
    unless(/^Drug_claim_primary_name/){  #原来的$cancer_oncotree_id变成了$indication_OncoTree_detail_ID
        my @f= split /\t/;
        my $Drug_claim_primary_name = $f[0];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_id =$f[2];
        my $cancer_oncotree_id_type =$f[3];
        my $predict = $f[4];
        my $predict_value = $f[5];
        my $Drug_indication_Indication_class =$f[6];
        my $indication_OncoTree_detail_ID = $f[7];
        my $indication_OncoTree_main_ID = $f[8];
        my $out1= "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_claim_primary_name";
        my $out2 = join("\t",@f[3..8]);
        if ($cancer_oncotree_id_type =~/oncotree_main_id/){  #是oncotree_main_id的$cancer_oncotree_detail_ID以$cancer_oncotree_id 填充,也就是原来的id
            my $cancer_oncotree_detail_ID = "$cancer_oncotree_id";
            my $cancer_oncotree_main_ID =$cancer_oncotree_id;
            my $out3 = "$cancer_oncotree_detail_ID\t$cancer_oncotree_main_ID";
            my $output = "$out1\t$out3\t$out2";
            unless (exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
        else{ #是oncotree_sub_id的$cancer_oncotree_mian_ID以oncotree_mian_ID填充
            my $cancer_oncotree_detail_ID = $cancer_oncotree_id;
            if (exists $hash1{$cancer_oncotree_detail_ID}){
                my $cancer_oncotree_main_ID = $hash1{$cancer_oncotree_detail_ID};
                my $out3 = "$cancer_oncotree_detail_ID\t$cancer_oncotree_main_ID";
                my $output = "$out1\t$out3\t$out2";
                unless (exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}