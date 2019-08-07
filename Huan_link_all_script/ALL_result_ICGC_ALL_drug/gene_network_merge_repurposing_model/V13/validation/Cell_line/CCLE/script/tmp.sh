perl 021_merge_sample_oncotree_chembl.pl
echo -e "021_merge_sample_oncotree_chembl\n"
perl 03_extract_snv_cnv_sv.pl
echo -e "03_extract_snv_cnv_sv\n"
perl 04_filter_snv_in_ICGC.pl
echo -e "04_filter_snv_in_ICGC\n"
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
Rscript 13_pandrug_comparison_boxplot.R
echo -e "13_pandrug_comparison_boxplot\n"
perl 14_top_prediction_sensitivity_comparsion.pl
echo -e "14_top_prediction_sensitivity_comparsion\n"
Rscript 15_pandrug_comparison_boxplot.R
echo -e "15_pandrug_comparison_boxplot\n"
perl 16_top_prediction_sensitivity_comparsion.pl
echo -e "16_top_prediction_sensitivity_comparsion\n"
Rscript 17_pandrug_comparison_boxplot.R
echo -e "17_pandrug_comparison_boxplot\n"
perl 18_top_prediction_sensitivity_comparsion.pl
echo -e "18_top_prediction_sensitivity_comparsion\n"
Rscript 19_pandrug_comparison_boxplot.R
echo -e "19_pandrug_comparison_boxplot\n"
perl 20_top_prediction_sensitivity_comparsion.pl
echo -e "20_top_prediction_sensitivity_comparsion\n"
Rscript 21_pandrug_comparison_boxplot.R
echo -e "21_pandrug_comparison_boxplot\n"
perl 22_top_prediction_sensitivity_comparsion.pl
echo -e "22_top_prediction_sensitivity_comparsion\n"
Rscript 23_pandrug_comparison_boxplot.R
echo -e "23_pandrug_comparison_boxplot\n"
perl 24_top_prediction_sensitivity_comparsion.pl
echo -e "24_top_prediction_sensitivity_comparsion\n"
Rscript 25_pandrug_comparison_boxplot.R
echo -e "25_pandrug_comparison_boxplot\n"