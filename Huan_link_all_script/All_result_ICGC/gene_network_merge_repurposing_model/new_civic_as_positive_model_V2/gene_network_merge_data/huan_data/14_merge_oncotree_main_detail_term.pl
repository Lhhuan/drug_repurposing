#用"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中的detail oncotree term 和 oncotree term 和 ./output/13_indication_and_cancer_lable_info.txt
# merge 到一起，得./output/14_merge_oncotree_main_detail_term.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./output/13_indication_and_cancer_lable_info.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/14_merge_oncotree_main_detail_term.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header= "Drug_chembl_id_Drug_claim_primary_name\tDrug_claim_primary_name";
$header = "$header\tcancer_oncotree_detail_ID\tcancer_oncotree_main_ID\tcancer_oncotree_detail_term\tcancer_oncotree_main_term";
$header = "$header\tcancer_oncotree_id_type\tpredict\tpredict_value\tDrug_indication_Indication_class\tindication_OncoTree_detail_ID\tindication_OncoTree_main_ID\tMax_phase\tFirst_approval\tcancer_lable";
print $O1 "$header\n";



my (%hash1,%hash2,%hash3,%hash4,%hash7,%hash9);
while(<$I1>)
{
    chomp;
    unless(/^project/){
        my @f= split /\t/;
        my $oncotree_detail_term = $f[-4];
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_term = $f[-2];
        my $oncotree_main_ID = $f[-1];
        my $k1 = "$oncotree_detail_ID\t$oncotree_main_ID";
        my $v1= "$oncotree_detail_term\t$oncotree_main_term";
        $hash1{$k1} =$v1;
        #-------------------------------------------------------为oncotree 的detail和main 相同的那些term准备
        my $k2 = "$oncotree_main_ID\t$oncotree_main_ID"; 
        my $v2= "$oncotree_main_term\t$oncotree_main_term";
        $hash1{$k2} =$v2;
    }
}


while(<$I2>)
{
    chomp;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my @f= split /\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_detail_ID = $f[2];
        my $cancer_oncotree_main_ID =$f[3];
        my $cancer_oncotree_id_type = $f[4];
        my $predict = $f[5];
        my $predict_value = $f[6];
        my $indication_OncoTree_detail_ID = $f[8];
        $indication_OncoTree_detail_ID =~ s/"//g;
        my $indication_OncoTree_main_ID = $f[9];
        $indication_OncoTree_main_ID =~s/"//g;
        my $Max_phase = $f[10];
        my $First_approval =$f[11];
        my $lable = $f[12];
        my $k = "$cancer_oncotree_detail_ID\t$cancer_oncotree_main_ID";
        if (exists $hash1{$k}){
            my $cancer_oncotree_term = $hash1{$k};
            my $output = join("\t",@f[0..3],$cancer_oncotree_term,@f[4..12]);
            unless (exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
        else{
            print "$k\n";
        }
    }
}



