# perl 02_filter_network_based_infos.pl
# echo -e "finish_02_filter_network_based_infos\n"
# perl 03_merge_gene_based_and_network_based_data.pl
# echo -e "finish_03_merge_gene_based_and_network_based_data\n"
# # perl 04_merge_sv_cnv_gene_network_based.pl
# # echo -e "finish_04_merge_sv_cnv_gene_network_based\n"
# perl 05_main_calculate_features_for_logistic_regression.pl
# echo -e "finish_05_main_calculate_features_for_logistic_regression\n"
# perl 05_sub_calculate_features_for_logistic_regression.pl
# echo -e "finish_05_sub_calculate_features_for_logistic_regression\n"
# perl 06_merge_sub_main_features_for_logistic_regression.pl
# echo -e "finish_06_merge_sub_main_features_for_logistic_regression\n"

perl 09_repurposing_Drug_claim_primary_name.pl
echo -e "finish_09_repurposing_Drug_claim_primary_name\n"
perl 10_merge_drug_indication.pl
echo -e "finish_10_merge_drug_indication\n"
perl 11_filter_drug_unique_status.pl
echo -e "finish_11_filter_drug_unique_status\n"
perl 12_merge_cancer_detail_main_ID.pl
echo -e "finish_12_merge_cancer_detail_main_ID\n"
perl 13_judge_indication_and_cancer_differ.pl
echo -e "finish_13_judge_indication_and_cancer_differ\n"