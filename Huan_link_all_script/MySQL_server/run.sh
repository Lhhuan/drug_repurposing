#AlleleDrugSM

#Drug_information
All_drug_information : "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt"
drug_max_phase : "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_unique_status.txt"
drug_indication_type: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/drug_indication_type.txt"
#cancer_information
pathogenicity_snv_indel_project_oncotree : "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt"
cancer_gene_role: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/normal_three_source_gene_role.txt"
pathogenicity_mutation_id_cadd_score: "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_id_cadd_score.txt"
pathogenicity_mutation_position: "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_mutation_postion.txt"
pathogenicity_sv_cnv: "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_SV_CNV/v4/output/all_pathogenicity_sv_snv_oncotree.vcf" #prediction

#drug-cancer pairs info
gene_based_drug_cancer_pairs_information: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt" #Logic true， conflict， no
network_based_drug_cancer_pairs_information: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic.txt.gz" #Logic true， conflict， no
gene_and_network_data_used_to_count_features： "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt.gz" #snv indel #prediction
model2_features: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/test_data/output/11_all_training_dataset.txt" #prediction
ICGC_based_drug_repurpose: 
