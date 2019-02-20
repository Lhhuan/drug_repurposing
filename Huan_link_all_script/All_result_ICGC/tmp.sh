perl 10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.pl
echo -e "10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene\n"
perl 11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.pl
echo -e "11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree\n"
perl 12_merge_ICGC_info_gene_role.pl
echo -e "12_merge_ICGC_info_gene_role\n"
perl 15_merge_cancer_gene_drug_indication_oncotree.pl
echo -e "15_merge_cancer_gene_drug_indication_oncotree\n"
perl 21_merge_drug_info_do_hpo_oncotree.pl
echo -e "21_merge_drug_info_do_hpo_oncotree\n"
perl find_original_drug_cancer_pair.pl 
echo -e "find_original_drug_cancer_pair\n"
perl 19_judge_ICGC_Indel_SNV_logic.pl
echo -e "19_judge_ICGC_Indel_SNV_logic\n"
perl 20_filter_may_success_repo_cancer.pl
echo -e "20_filter_may_success_repo_cancer\n"
perl extract_drug_gene_repo_indication.pl
echo -e "extract_drug_gene_repo_indication\n"
perl merge_huan_drug_target_score.pl
echo -e "merge_huan_drug_target_score\n"
perl extract_drug_target_score.pl
echo -e "extract_drug_target_score\n"