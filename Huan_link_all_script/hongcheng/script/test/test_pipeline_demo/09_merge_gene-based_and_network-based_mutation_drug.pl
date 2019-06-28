#将./output/04_judge_gene_based_logic_mutation_cancer_gene_and_drug_target.txt 和./output/08_judge_mutation_drug_target_network_based_logic.txt.gz merge 到一起，
#得./output/09_merge_gene-based_and_network-based_mutation_drug.txt.gz
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/04_judge_gene_based_logic_mutation_cancer_gene_and_drug_target.txt";
my $f2 ="./output/08_judge_mutation_drug_target_network_based_logic.txt.gz";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n"); #读压缩文件
my $fo1 ="./output/09_merge_gene-based_and_network-based_mutation_drug.txt.gz"; 
open my $O1, "| gzip >$fo1" or die $!;
my $header = "Variant_id\tCancer_gene_ENSG\tcancer_entrez\tConsequence\tProtein\tB_sift_score\tmutation_to_gene_moa\tTumour_Types\tcancer_gene_normal_MOA\tMOA_rule\tDrug_chembl_id_Drug_claim_primary_name";
$header = "$header\tdrug_target_Gene_symbol\tdrug_target_Entrez_id\tDrug_claim_primary_name\tDrug_chembl_id\tDrug_type\tMax_phase\tFirst_approval\tClinical_phase\tDrug_indication_Indication_class\tIndication_ID";
$header = "$header\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\tdrug_target_score\tPACTIVITY_median";
$header = "$header\tfinal_logic\tshortest_path\tstart_id\tstart_entrez\trandom_overlap_fact_end\tnormal_score_P\tshortest_path_length\tpath_logic_direction\tsource";
print $O1 "$header\n";
my %hash1;
my %hash2;


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Variant_id/){
        my $Variant_id = $f[0];
        my $ENSG =$f[1];
        my $Consequence =$f[2];
        my $Protein = $f[3];
        my $B_sift_score = $f[4];
        my $mutation_to_gene_moa = $f[5];
        my $cancer_entrez =$f[6];
        my $Tumour_Types = $f[7];
        my $cancer_gene_normal_MOA =$f[8];
        my $MOA_rule = $f[9];
        my $Drug_chembl_id_Drug_claim_primary_name =$f[10];
        my $Gene_symbol = $f[11];
        my $drug_target_Entrez_id = $f[12];
        my $Drug_claim_primary_name = $f[13];
        my $Drug_chembl_id =$f[14];
        my $Max_phase = $f[15];
        my $First_approval =$f[16];
        my $Clinical_phase =$f[17];
        my $Drug_indication_Indication_class = $f[18];
        my $Indication_ID =$f[19];
        my $Drug_type =$f[20];
        my $indication_OncoTree_term_detail =$f[21];
        my $indication_OncoTree_IDs_detail =$f[22];
        my $indication_OncoTree_main_term =$f[23];
        my $indication_OncoTree_main_ID =$f[24];
        my $drug_target_score =$f[25];
        my $PACTIVITY_median = $f[26];
        my $final_logic =$f[27];
        my $shortest = "${ENSG}_${ENSG}";
        my $start_id = "NA";
        my $start_entrez ="NA";
        my $random_overlap_fact_end ="NA";
        my $normal_score_P ="0";
        my $source ="gene_based";
        my $shortest_path_length ="0";
        my $path_logic_direction ="NA";
        my $output = "$Variant_id\t$ENSG\t$cancer_entrez\t$Consequence\t$Protein\t$B_sift_score\t$mutation_to_gene_moa\t$Tumour_Types\t$cancer_gene_normal_MOA\t$MOA_rule\t$Drug_chembl_id_Drug_claim_primary_name";
        $output = "$output\t$Gene_symbol\t$drug_target_Entrez_id\t$Drug_claim_primary_name\t$Drug_chembl_id\t$Drug_type\t$Max_phase\t$First_approval\t$Clinical_phase\t$Drug_indication_Indication_class\t$Indication_ID";
        $output = "$output\t$indication_OncoTree_term_detail\t$indication_OncoTree_IDs_detail\t$indication_OncoTree_main_term\t$indication_OncoTree_main_ID\t$drug_target_score\t$PACTIVITY_median";
        $output = "$output\t$final_logic\t$shortest\t$start_id\t$start_entrez\t$random_overlap_fact_end\t$normal_score_P\t$shortest_path_length\t$path_logic_direction\t$source";
        print $O1 "$output\n";
    }
}



while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^network_drug_name/){
        my $shortest =$f[0];
        my $path_logic_direction =$f[1];
        my $shortest_path_length =$f[2];
        my $network_drug_name = $f[3];
        my $start_id = $f[4];
        my $start_entrez = $f[5];
        my $random_overlap_fact_end= $f[6];
        my $normal_score_P = $f[7];
        my $cancer_entrez = $f[8];
        my $Variant_id = $f[9];
        my $ENSG = $f[10];
        my $Consequence = $f[11];
        my $Protein = $f[12];
        my $B_sift_score = $f[13];
        my $mutation_to_gene_moa = $f[14];
        my $Cancer_Entrez = $f[15];
        my $Tumour_Types = $f[16];
        my $cancer_gene_normal_MOA = $f[17];
        my $MOA_rule =$f[18];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[19];
        my $Gene_symbol = $f[20];
        my $drug_target_Entrez_id = $f[21];
        my $Drug_claim_primary_name = $f[22];
        my $Drug_chembl_id = $f[23];
        my $Max_phase = $f[24];
        my $First_approval =$f[25];
        my $Clinical_phase =$f[26];
        my $Drug_indication_Indication_class = $f[27];
        my $Indication_ID = $f[28];
        my $Drug_type =$f[29];
        my $indication_OncoTree_term_detail =$f[30];
        my $indication_OncoTree_IDs_detail = $f[31];
        my $indication_OncoTree_main_term = $f[32];
        my $indication_OncoTree_main_ID = $f[33];
        my $drug_target_score = $f[34];
        my $PACTIVITY_median =$f[35];
        my $drug_target_network_id =$f[36];
        my $final_logic =$f[37]; 
        my $source = "network-based";
        # print "$Variant_id\n";
        my $output = "$Variant_id\t$ENSG\t$cancer_entrez\t$Consequence\t$Protein\t$B_sift_score\t$mutation_to_gene_moa\t$Tumour_Types\t$cancer_gene_normal_MOA\t$MOA_rule\t$Drug_chembl_id_Drug_claim_primary_name";
        $output = "$output\t$Gene_symbol\t$drug_target_Entrez_id\t$Drug_claim_primary_name\t$Drug_chembl_id\t$Drug_type\t$Max_phase\t$First_approval\t$Clinical_phase\t$Drug_indication_Indication_class\t$Indication_ID";
        $output = "$output\t$indication_OncoTree_term_detail\t$indication_OncoTree_IDs_detail\t$indication_OncoTree_main_term\t$indication_OncoTree_main_ID\t$drug_target_score\t$PACTIVITY_median";
        $output = "$output\t$final_logic\t$shortest\t$start_id\t$start_entrez\t$random_overlap_fact_end\t$normal_score_P\t$shortest_path_length\t$path_logic_direction\t$source";
        print $O1 "$output\n";
    }
}
