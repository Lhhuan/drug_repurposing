##判断12_ICGC_snv_indel_network_drug_indication_cancer.txt的cancer oncotree 和indication 的oncotree是否是同一种疾病。得是同一疾病的文件13_network_based_ICGC_somatic_repo_indication_cancer_same.txt
#得不是同一种疾病的文件，并把不是start的drug target 过滤掉得13_network_based_ICGC_somatic_repo_indication_cancer_differ.txt,是否真的repo成功，还需要再check
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
####system "sort 12_ICGC_snv_indel_network_drug_indication_cancer.txt | uniq > 12_ICGC_snv_indel_network_drug_indication_cancer_sorted.txt";
my $f1 ="./12_ICGC_snv_indel_network_drug_indication_cancer.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./13_network_based_ICGC_somatic_repo_indication_cancer_same.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./13_network_based_ICGC_somatic_repo_indication_cancer_differ.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $header ="drug_name_network\tstart_id\tstart_entrez\trandom_overlap_fact_end_id\tnormal_score_P\tend_entrze\tCADD_MEANPHRED\tMutation_ID\tENSG\tMap_to_gene_level\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail";
$header = "$header\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$header ="$header\tDrug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication";
$header = "$header\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail";
$header = "$header\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\tdrug_target_score";
print $O1 "$header\n";
print $O2 "$header\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug_name_network/){
         my $ICGC_cancer_oncotree_main_id =$f[18];
         my $indication_oncotree_main_id = $f[-2];
         if ($ICGC_cancer_oncotree_main_id eq $indication_oncotree_main_id){  #判断原有适应症和癌症是否是同一疾病。
             print $O1 "$_\n";
         }
         else{
             my %hash1;
             my $start_entrez =$f[2];
             my $drug_target_entrez = $f[22];
             my @starts =split/,/,$start_entrez;
             foreach my $start(@starts){
                 $hash1{$start}=1;
             }
             if(exists $hash1{$drug_target_entrez}){  #取出是drug start的gene
                print $O2 "$_\n";
             }
         }
     }
}

