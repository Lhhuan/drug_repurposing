# perl 02_merge_cnv_snv_all_project.pl
# echo -e "finish_02_merge_cnv_snv_all_project\n"
# perl 03_arrange_28847918_to_normal_type.pl
# echo -e "finish_03_arrange_28847918_to_normal_type\n"
# perl 04_test_sample_drug_in_huan_data.pl
# echo -e "finish_04_test_sample_drug_in_huan_data\n"
perl 05_filter_04_overlap_drug_sample_info.pl
echo -e "finish_05_filter_04_overlap_drug_sample_info\n"
perl 06_filter_snv_in_icgc.pl 
echo -e "finish_06_filter_snv_in_icgc\n"
perl 07_filter_snv_in_huan.pl
echo -e "finish_07_filter_snv_in_huan\n"
perl 08_filter_cnv_in_huan.pl
echo -e "finish_08_filter_cnv_in_huan\n"
perl 09_calculate_features_for_logistic_regression.pl
echo -e "finish_09_calculate_features_for_logistic_regression\n"