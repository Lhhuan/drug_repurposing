# perl 02_filter_network_based_infos.pl
# echo -e "finish_02_filter_network_based_infos\n"
# perl 03_merge_gene_based_and_network_based_data.pl
# echo -e "finish_03_merge_gene_based_and_network_based_data\n"
# perl 04_merge_sv_cnv_gene_network_based.pl
# echo -e "finish_04_merge_sv_cnv_gene_network_based\n"
perl 05_main_calculate_features_for_logistic_regression.pl
echo -e "finish_05_main_calculate_features_for_logistic_regression\n"
perl 05_sub_calculate_features_for_logistic_regression.pl
echo -e "finish_05_sub_calculate_features_for_logistic_regression\n"
perl 06_merge_sub_main_features_for_logistic_regression.pl
echo -e "finish_06_merge_sub_main_features_for_logistic_regression\n"