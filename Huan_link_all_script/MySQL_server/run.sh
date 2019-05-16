#AlleleDrugSM

#Drug_information
All_drug_information : "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt"
=Drug_target_information 
+Drug_claim_primary_name 
+Drug_chembl_id 
+Drug_indication 
+Drug_indication_map_information
Drug_max_phase : "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_unique_status.txt"
Drug_indication_type: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/drug_indication_type.txt"
#cancer_information
Pathogenicity_snv_indel_map_to_gene_project： "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.txt"
Project_oncotree: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"
Cancer_gene_role: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/normal_three_source_gene_role.txt"
Pathogenicity_mutation_id_cadd_score: "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_id_cadd_score.txt"
Pathogenicity_mutation_position: "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_mutation_postion.txt"
# mutation_map_to_gene_level:"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/all_somatic_snv_indel_mutationID_ensg_entrez.txt"
Pathogenicity_sv_cnv: "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_SV_CNV/v4/output/all_pathogenicity_sv_snv_oncotree.vcf" #prediction

#drug-cancer pairs info
Gene_based_drug_cancer_pairs_information: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt" #Logic true， conflict， no
Gene_based_drug_cancer_pairs_information：
Network_based_drug_cancer_pairs_information: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic.txt.gz" #Logic true， conflict， no
=Network_based_drug_cancer_pairs_information_logic_true
+Network_based_drug_cancer_pairs_information_logic_conflict
+Network_based_drug_cancer_pairs_information_logic_no
Gene_and_network_data_used_to_count_features： "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt.gz" #snv indel #prediction
Model2_features: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/test_data/output/11_all_training_dataset.txt" #prediction
ICGC_based_drug_repurposing: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/huan_data/output/14_out_of_training_dataset_repurposing_label.txt" #

perl 01_split_All_drug_information.pl #将All_drug_information 分隔成./data/Drug_target_information.txt, ./data/Drug_claim_primary_name.txt,./data/Drug_chembl_id.txt,  ./data/Drug_indication.txt 和./data/Drug_indication_map_information.txt
perl 02_filter_Gene_based_drug_cancer_pairs.pl # 对Gene_based_drug_cancer_pairs_information： "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt"进行过滤
#得./data/Gene_based_drug_cancer_pairs_information.txt
perl 03_filter_Network_based_drug_cancer_pairs.pl #Network_based_drug_cancer_pairs_information: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic.txt.gz"
#进行过滤./data/Network_based_drug_cancer_pairs_information.txt