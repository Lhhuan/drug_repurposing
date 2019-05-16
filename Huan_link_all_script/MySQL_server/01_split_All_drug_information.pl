#将All_drug_information 分隔成./data/Drug_target_information.txt, ./data/Drug_claim_primary_name.txt,./data/Drug_chembl_id.txt,  ./data/Drug_indication.txt 和./data/Drug_indication_map_information.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./data/Drug_target_information.txt"; 
my $fo2 ="./data/Drug_claim_primary_name.txt";
my $fo3 ="./data/Drug_chembl_id.txt"; 
my $fo4 ="./data/Drug_indication.txt"; 
my $fo5 ="./data/Drug_indication_map_information.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
open my $O5, '>', $fo5 or die "$0 : failed to open output file '$fo5' : $!\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5); 

print $O1 "Drug_chembl_id_Drug_claim_primary_name\tGene_symbol\tEntrez_id\tENSG_ID\tInteraction_types\tDrug_type\tFinal_source\tDrug_target_score\n";
print $O2 "Drug_chembl_id_Drug_claim_primary_name\tDrug_claim_primary_name\n";
print $O3 "Drug_chembl_id_Drug_claim_primary_name\tDrug_chembl_id\n";
print $O4 "Drug_chembl_id_Drug_claim_primary_name\tMax_phase\tFirst_approval\tLink_Refs\tIndication_class\tDrug_indication\tDrug_indication_Indication_class\tIndication_ID\tDrug_indication_source\n";
print $O5 "Indication_ID\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\n";
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){  
        my $Drug_chembl_id_Drug_claim_primary_name =$f[0];
        my $Gene_symbol= $f[1];
        my $Entrez_id = $f[2];
        my $Interaction_types = $f[3];
        my $Drug_claim_primary_name = $f[4];
        my $Drug_chembl_id = $f[5];
        my $Max_phase = $f[6];
        my $First_approval= $f[7];
        my $Indication_class = $f[8];
        my $Drug_indication = $f[9];
        my $Drug_indication_source = $f[10];
        my $Clinical_phase = $f[11];
        my $Link_Refs = $f[12];
        my $Drug_indication_Indication_class = $f[13];
        my $ENSG_ID = $f[14];
        my $Final_source = $f[15];
        my $Indication_ID= $f[16];
        my $Drug_type = $f[17];
        my $DOID= $f[18];
        my $DO_term = $f[19];
        my $HPO_ID = $f[20];
        my $HPO_term = $f[21];
        my $indication_OncoTree_term_detail = $f[22];
        my $indication_OncoTree_IDs_detail = $f[23];
        my $indication_OncoTree_main_term =$f[24];
        my $indication_OncoTree_main_ID = $f[25];
        my $drug_target_score = $f[26];
        my $output1 = "$Drug_chembl_id_Drug_claim_primary_name\t$Gene_symbol\t$Entrez_id\t$ENSG_ID\t$Interaction_types\t$Drug_type\t$Final_source\t$drug_target_score";
        unless (exists $hash1{$output1}){
            $hash1{$output1} =1;
            print $O1 "$output1\n"; 
        }
        unless($Drug_claim_primary_name =~/\bNA|NONE|NULL\b/){
            my $output2 = "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_claim_primary_name";
            unless (exists $hash2{$output2}){
                $hash2{$output2}=1;
                print $O2 "$output2\n";
            }
        }
        unless($Drug_chembl_id =~/\bNA|NONE|NULL\b/){
            my $output3 = "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_chembl_id";
            unless(exists $hash3{$output3}){
                $hash3{$output3} =1;
                print $O3 "$output3\n";
            }
        }
        my $output4 = "$Drug_chembl_id_Drug_claim_primary_name\t$Max_phase\t$First_approval\t$Link_Refs\t$Indication_class\t$Drug_indication\t$Drug_indication_Indication_class\t$Indication_ID\t$Drug_indication_source";
        unless(exists $hash4{$output4}){
            $hash4{$output4} =1;
            print $O4 "$output4\n";
        }
        my $output5 = "$Indication_ID\t$DOID\t$DO_term\t$HPO_ID\t$HPO_term\t$indication_OncoTree_term_detail\t$indication_OncoTree_IDs_detail\t$indication_OncoTree_main_term\t$indication_OncoTree_main_ID";
        unless (exists $hash5{$output5}){
            $hash5{$output5}=1;
            print $O5 "$output5\n";
        }

    }
}


