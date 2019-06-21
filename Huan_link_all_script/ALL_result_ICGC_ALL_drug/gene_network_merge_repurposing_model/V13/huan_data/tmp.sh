perl 01_filter_gene_based_drug_cancer_mutation_info.pl
echo -e "finish_01_filter_gene_based_drug_cancer_mutation_info\n"
perl 02_filter_network_based_infos.pl
echo -e "finish_02_filter_network_based_infos\n"
perl 03_merge_gene_based_and_network_based_data.pl
echo -e "finish_03_merge_gene_based_and_network_based_data\n"
perl 05_sub_calculate_features_for_logistic_regression.pl
echo -e "finish_05_sub_calculate_features_for_logistic_regression\n"
perl 05_main_calculate_features_for_logistic_regression.pl
echo -e "finish_05_main_calculate_features_for_logistic_regression\n"
perl 06_merge_sub_main_features_for_logistic_regression.pl
echo -e "finish_06_merge_sub_main_features_for_logistic_regression\n"

# Rscript 08_prediction_drug_repurposing_normal.R 
# echo -e "finish_08_prediction_drug_repurposing_normal\n"
# perl 09_filter_training_dataset_repurposing_data.pl
# echo -e "finish_09_filter_training_dataset_repurposing_data\n"
# perl 10_merge_drug_claim_primary_name.pl
# echo -e "finish_10_merge_drug_claim_primary_name\n"
# perl 11_merge_drug_indication.pl
# echo -e "finish_11_merge_drug_indication\n"
# perl 12_merge_cancer_detail_main_ID.pl
# echo -e "finish_12_merge_cancer_detail_main_ID\n"
# perl 13_judge_indication_and_cancer_differ.pl
# echo -e "finish_13_judge_indication_and_cancer_differ\n"
# perl 14.1_merge_indication_and_cancer_lable.pl
# echo -e "finish_14.1_merge_indication_and_cancer_lable\n"
# perl 14_merge_oncotree_main_detail_term.pl
# echo -e "finish_14_merge_oncotree_main_detail_term\n"
# perl 15_split_drug_repurposing_and_drug_indication.pl
# echo -e "finish_15_split_drug_repurposing_and_drug_indication\n"
# perl 17_count_drug_cancer_pair_actionable_number.pl
# echo -e "finish_17_count_drug_cancer_pair_actionable_number\n"
# perl 18_merge_actionable_number_and_prediction_value.pl
# echo -e "finish_18_merge_actionable_number_and_prediction_value\n"
# Rscript 19_actionable_number_and_prediction_value_correlative.R
# echo -e "finish_19_actionable_number_and_prediction_value_correlative\n"

