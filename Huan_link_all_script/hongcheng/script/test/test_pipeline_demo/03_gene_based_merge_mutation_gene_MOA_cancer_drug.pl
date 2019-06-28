#将通过cancer gene 和 drug target 将mutation 和drug link 起来。即./output/02_merge_mutation_gene_MOA_and_cancer.txt 和
#"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score_bioactivities.txt" merge 到一起，得./output/03_gene_based_merge_mutation_gene_MOA_cancer_drug.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score_bioactivities.txt";
my $f2 ="./output/02_merge_mutation_gene_MOA_and_cancer.txt";
my $fo1 ="./output/03_gene_based_merge_mutation_gene_MOA_cancer_drug.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $output= "Variant_id\tENSG\tConsequence\tProtein\tB_sift_score\tmutation_to_gene_moa\tEntrez\tTumour_Types\tcancer_gene_normal_MOA\tMOA_rule";
$output = "$output\tDrug_chembl_id_Drug_claim_primary_name\tGene_symbol\tEntrez_id\tDrug_claim_primary_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tClinical_phase\tDrug_indication_Indication_class\tIndication_ID";
$output = "$output\tDrug_type\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\tdrug_target_score\tPACTIVITY_median";
print $O1 "$output\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);


while(<$I1>)
{
    chomp;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my @f= split /\t/;
        my $Drug_chembl_id_Drug_claim_primary_name =$f[0];
        my $Gene_symbol = $f[1];
        my $Entrez_id = $f[2];
        my $Drug_claim_primary_name= $f[4];
        my $Drug_chembl_id =$f[5];
        my $Max_phase =$f[6];
        my $First_approval =$f[7];
        my $Clinical_phase =$f[11];
        my $Drug_indication_Indication_class =$f[13];
        my $ENSG_ID =$f[14];
        my $Indication_ID = $f[16];
        my $Drug_type = $f[17];
        my $indication_OncoTree_term_detail =$f[22];
        my $indication_OncoTree_IDs_detail =$f[23];
        my $indication_OncoTree_main_term =$f[24];
        my $indication_OncoTree_main_ID =$f[25];
        my $drug_target_score =$f[26];
        my $PACTIVITY_median = $f[27];
        my $v= "$Drug_chembl_id_Drug_claim_primary_name\t$Gene_symbol\t$Entrez_id\t$Drug_claim_primary_name\t$Drug_chembl_id\t$Max_phase\t$First_approval\t$Clinical_phase\t$Drug_indication_Indication_class\t$Indication_ID";
        $v= "$v\t$Drug_type\t$indication_OncoTree_term_detail\t$indication_OncoTree_IDs_detail\t$indication_OncoTree_main_term\t$indication_OncoTree_main_ID\t$drug_target_score\t$PACTIVITY_median";
        push @{$hash1{$ENSG_ID}},$v;
    }
}


while(<$I2>)
{
    chomp;
    unless(/^Variant_id/){
        my @f= split /\t/;
        my $Variant_id = $f[0];
        my $ENSG = $f[1];
        if (exists $hash1{$ENSG}){
            my @vs = @{$hash1{$ENSG}};
            foreach my $v(@vs){
                my $output ="$_\t$v";
                # unless (exists $hash2{$output}){
                    # $hash2{$output} =1;
                print $O1 "$output\n";
                # }
            }
        }
        # else{
        #     print "$ENSG\n";
        # }
    }
}
