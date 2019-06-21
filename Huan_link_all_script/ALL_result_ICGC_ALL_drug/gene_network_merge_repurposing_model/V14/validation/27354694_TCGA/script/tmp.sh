perl 04_test_sample_drug_in_huan_data.pl 
echo -e "finish_04_test_sample_drug_in_huan_data\n"
perl 05_filter_04_overlap_drug_sample_info.pl
echo -e "finish_05_filter_04_overlap_drug_sample_info\n"
perl 06_filter_snv_in_pathogenicity_icgc.pl
echo -e "finish_06_filter_snv_in_pathogenicity_icgc\n"
perl 06_count_sample_pathogenicity_mutation_number.pl
echo -e "finish_06_count_sample_pathogenicity_mutation_number\n"
perl 07_filter_snv_in_huan.pl
echo -e "finish_07_filter_snv_in_huan\n"
perl 08_filter_cnv_in_huan.pl
echo -e "finish_08_filter_cnv_in_huan\n"
perl 09_calculate_features_for_logistic_regression.pl
echo -e "finish_09_calculate_features_for_logistic_regression\n"
