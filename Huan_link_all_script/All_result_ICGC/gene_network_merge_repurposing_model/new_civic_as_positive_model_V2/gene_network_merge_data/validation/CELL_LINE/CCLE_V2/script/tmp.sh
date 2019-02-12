perl 05_filter_snv_in_huan.pl
echo -e "05_filter_snv_in_huan\n"
perl 06_filter_cnv_in_huan.pl
echo -e "06_filter_CNV_in_huan\n"
perl 0701_sort_tra_sample.pl
echo -e "0701_sort_tra_sample\n"
perl 07_filter_TRA_in_huan.pl
echo -e "07_filter_TRA_in_huan\n"
perl 08_merge_all_sv.pl
echo -e "08_merge_all_sv\n"
perl 09_calculate_features_for_logistic_regression.pl
echo -e "09_calculate_features_for_logistic_regression\n"
Rscript 10_prediction_repurposing.R
echo -e "10_prediction_repurposing\n"
perl 11_merge_prediction_repurposing_drug_sensitive_info.pl
echo -e "11_merge_prediction_repurposing_drug_sensitive_info\n"
cat ../output/11_merge_prediction_repurposing_drug_sensitive_info.txt |cut -f1,2,3,4,19,20,21 >../output/11_merge_prediction_repurposing_drug_sensitive_info_sample.txt
perl 12_top_prediction_sensitivity_comparsion.pl 
echo -e "12_top_prediction_sensitivity_comparsion\n"
#Rscript 13_pandrug_comparison_boxplot.R