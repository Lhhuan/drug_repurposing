# perl 001_merge_repoDB_oncotree.pl
# perl 002_extract_drug_info_for_repo_data.pl
# perl 003_merge_repo_cancer_gene.pl
# perl 004_merge_two_source_data.pl
# perl 01_judge_drug_target_and_cancer_differ.pl
# echo -e "01_judge_drug_target_and_cancer_differ\n"
perl 02_merge_drug_name_data_for_logistic_regression.pl
echo -e "finish_02_merge_drug_name_data_for_logistic_regression\n"
perl 03_filter_repo_withdrwal_data_for_logistic_regression.pl
echo -e "finish_03_filter_repo_withdrwal_data_for_logistic_regression\n"