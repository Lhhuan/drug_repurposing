# perl 02_filter_infos_for_calculate_feature_final.pl
# echo -e "finish_02_filter_infos_for_calculate_feature_final\n"
# perl 021_add_CNV_dup_del_info_for_calculate_feature.pl
# echo -e "finish_021_add_CNV_dup_del_info_for_calculate_feature\n"
# perl 021_calculate_average_tra_inv.pl
# echo -e "finish_021_calculate_average_tra_inv\n"
# perl 03_calculate_for_network_based_repo_logistic_regression_data_CNV_dup_del.pl
# echo -e "finish_03_calculate_for_network_based_repo_logistic_regression_data_CNV_dup_del\n"
# perl 031_merge_final_network_based_repo_logistic_regression_data_SV.pl
# echo -e "finish_031_merge_final_network_based_repo_logistic_regression_data_SV\n"
perl 05_merge_drug_cancer_network_based_prediction_potential_drug_repurposing.pl
echo -e "05_merge_drug_cancer_network_based_prediction_potential_drug_repurposing\n"
perl 06_merge_05_drug_indication.pl
echo -e "06_merge_05_drug_indication\n"
perl 07_judge_indication_and_cancer_differ.pl
echo -e "07_judge_indication_and_cancer_differ\n"
perl 08_filter_drug_status_unique_drug_repurposing.pl 
echo -e "08_filter_drug_status_unique_drug_repurposing\n"