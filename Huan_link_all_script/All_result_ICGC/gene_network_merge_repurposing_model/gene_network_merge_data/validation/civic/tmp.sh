# perl 02_merge_oncotree.pl
# echo -e "finish_02_merge_oncotree\n"
# perl 03_flter_huan_prediction_in_Sensitivity.pl
# echo -e "03_flter_huan_prediction_in_Sensitivity\n"
# perl 04_filter_transvar_type.pl
# echo -e "04_filter_transvar_type\n"
perl 05_merge_transvar.pl
echo -e "05_merge_transvar\n"
perl 06_extract_ICGC_mutation_id_HVSGg.pl
echo -e "06_extract_ICGC_mutation_id_HVSGg\n"
perl 07_filter_mutation_in_ICGC.pl
echo -e "07_filter_mutation_in_ICGC\n"
perl 08_unique_07_info_merge_drug_chembl.pl
echo -e "08_unique_07_info_merge_drug_chembl\n"
perl 09_filter_mutation_drug_cancer_pair_in_huan_data.pl
echo -e "09_filter_mutation_drug_cancer_pair_in_huan_data\n"
perl 10_calculate_features_for_logistic_regression.pl
echo -e "10_calculate_features_for_logistic_regression\n"