
perl 01_filter_drug_indication_as_cancer.pl
echo -e "finish_01_filter_drug_indication_as_cancer\n"
perl 02_new_positive_and_nagetive.pl
echo -e "finish_02_new_positive_and_nagetive\n"
perl 08_merge_drug_name_data_for_logistic_regression.pl
echo -e "finish_08_merge_drug_name_data_for_logistic_regression\n"
perl 09_filter_test_data_for_logistic_regression.pl
echo -e "finish_09_filter_test_data_for_logistic_regression\n"
