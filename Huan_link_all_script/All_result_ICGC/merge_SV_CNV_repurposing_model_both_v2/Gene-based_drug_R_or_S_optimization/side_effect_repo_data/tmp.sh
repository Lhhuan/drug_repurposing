perl 05_extract_drug_info_for_repo_side-effect_data.pl
echo -e "05_extract_drug_info_for_repo_side-effect_data\n"
perl 06_merge_repo_side-effect_cancer_gene.pl
echo -e "06_merge_repo_side-effect_cancer_gene\n"
perl 07_judge_drug_target_and_cancer_same_and_logic.pl
echo -e "07_judge_drug_target_and_cancer_same_and_logic\n"
perl 08_filter_logic_know_info.pl
echo -e "08_filter_logic_know_info\n"
perl 09_prepare_data_for_repo_logistic_regression.pl
echo -e "09_prepare_data_for_repo_logistic_regression\n"