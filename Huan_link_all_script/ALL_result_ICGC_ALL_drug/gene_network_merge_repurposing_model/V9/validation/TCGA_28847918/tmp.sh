perl 04_test_sample_drug_in_huan_data.pl
echo -e "04_test_sample_drug_in_huan_data\n"
perl 041_filter_gdsc_drug_wtih_04_no.pl
echo -e "041_filter_gdsc_drug_wtih_04_no\n"
perl 042_filter_sample.pl
echo -e "042_filter_sample\n"
perl 05_filter_04_overlap_drug_sample_info.pl
echo -e "05_filter_04_overlap_drug_sample_info\n"
perl 06_filter_snv_in_pathogenicity_icgc.pl
echo -e "06_filter_snv_in_pathogenicity_icgc\n"
perl 06_count_sample_pathogenicity_mutation_number.pl
echo -e "06_count_sample_pathogenicity_mutation_number\n"
perl 07_filter_snv_in_huan.pl
echo -e "07_filter_snv_in_huan\n"
perl 08_filter_cnv_in_huan.pl
echo -e "08_filter_cnv_in_huan\n"
perl 09_calculate_features_for_logistic_regression.pl
echo -e "09_calculate_features_for_logistic_regression\n"