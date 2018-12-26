#筛选../output/09_filter_test_data_for_logistic_regression.txt 中在"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"中的信息，
#得./output/01_filter_sample_drug_info.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt";
my $f2 ="../output/09_filter_test_data_for_logistic_regression.txt";
my $fo1 ="./output/01_filter_sample_drug_info.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
my $header= "Drug_chembl_id_Drug_claim_primary_name\tDrug_claim_primary_name\tMax_phase\tFirst_approval\tDrug_indication_Indication_class\tIndication_ID\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail";
$header= "$header\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\trepo_cancer_oncotree_id\trepo_cancer_oncotree_id_type\trepurposing";
print $O1 "$header\n";
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name = $f[4];
        my $Max_phase = $f[6];
        my $First_approval =$f[7];
        my $Drug_indication_Indication_class = $f[13];
        my $Indication_ID = $f[16];
        my $Drug_type = $f[17];
        my $DOID = $f[18];
        my $DO_term = $f[19];
        my $HPO_ID = $f[20];
        my $HPO_term = $f[21];
        my $indication_OncoTree_term_detail = $f[22];
        my $indication_OncoTree_IDs_detail = $f[23];
        my $indication_OncoTree_main_term = $f[24];
        my $indication_OncoTree_main_ID = $f[25];
        my $v= "$Drug_claim_primary_name\t$Max_phase\t$First_approval\t$Drug_indication_Indication_class\t$Indication_ID\t$Drug_type\t$DOID\t$DO_term\t$HPO_ID\t$HPO_term\t$indication_OncoTree_term_detail";
        $v = "$v\t$indication_OncoTree_IDs_detail\t$indication_OncoTree_main_term\t$indication_OncoTree_main_ID";
        push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^cancer_oncotree_id_type/){
        my $cancer_oncotree_id_type = $f[0];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_id = $f[2];
        my $repurposing = $f[-1];
        if (exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){
            my @drug_infos = @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}};
            foreach my $drug_info(@drug_infos){
                my $output=  "$Drug_chembl_id_Drug_claim_primary_name\t$drug_info\t$cancer_oncotree_id\t$cancer_oncotree_id_type\t$repurposing";
                unless (exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

