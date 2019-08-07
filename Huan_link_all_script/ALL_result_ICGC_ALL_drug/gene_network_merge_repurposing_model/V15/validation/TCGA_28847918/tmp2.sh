Rscript 10_predict_TCGA_data.R
echo -e "10_predict_TCGA_data\n"
perl 11_merge_prediction_and_icgc_result.pl
echo -e "11_merge_prediction_and_icgc_result\n"
perl 15_refine_pandrug_top_drug_sensitivity_comparison.pl
echo -e "15_refine_pandrug_top_drug_sensitivity_comparison\n"
Rscript 16_pandrug_comparison_boxplot.R
echo -e "16_pandrug_comparison_boxplot\n"
perl 17_pandrug_top_drug_sensitivity_comparison.pl 
echo -e "17_pandrug_top_drug_sensitivity_comparison\n"
Rscript 18_pandrug_comparison_boxplot.R
echo -e "18_pandrug_comparison_boxplot\n"
perl 19_pandrug_top_drug_sensitivity_comparison.pl
echo -e "19_pandrug_top_drug_sensitivity_comparison\n"
Rscript 20_pandrug_comparison_boxplot.R
echo -e "20_pandrug_comparison_boxplot\n"
perl 21_pandrug_top_drug_sensitivity_comparison.pl 
echo -e "21_pandrug_top_drug_sensitivity_comparison\n"
Rscript 22_pandrug_comparison_boxplot.R 
echo -e "22_pandrug_comparison_boxplot\n"
perl 23_pandrug_top_drug_sensitivity_comparison.pl
echo -e "23_pandrug_top_drug_sensitivity_comparison\n"
Rscript 24_pandrug_comparison_boxplot.R
echo -e "24_pandrug_comparison_boxplot\n"
perl 25_pandrug_top_drug_sensitivity_comparison.pl
echo -e "25_pandrug_top_drug_sensitivity_comparison\n"
Rscript 26_pandrug_comparison_boxplot.R 
echo -e "26_pandrug_comparison_boxplot\n"
perl 27_pandrug_top_drug_sensitivity_comparison.pl
echo -e "27_pandrug_top_drug_sensitivity_comparison\n"
Rscript 28_pandrug_comparison_boxplot.R
echo -e "28_pandrug_comparison_boxplot\n"
perl 29_pandrug_top_drug_sensitivity_comparison.pl
echo -e "29_pandrug_top_drug_sensitivity_comparison\n"
Rscript 30_pandrug_comparison_boxplot.R
echo -e "30_pandrug_comparison_boxplot\n"
perl 31_pandrug_top_drug_sensitivity_comparison.pl
echo -e "31_pandrug_top_drug_sensitivity_comparison\n"
Rscript 32_pandrug_comparison_boxplot.R 
echo -e "32_pandrug_comparison_boxplot\n"
perl 33_pandrug_top_drug_sensitivity_comparison.pl
echo -e "33_pandrug_top_drug_sensitivity_comparison\n"
Rscript 34_pandrug_comparison_boxplot.R
echo -e "34_pandrug_comparison_boxplot\n"
perl 35_pandrug_top_drug_sensitivity_comparison.pl
echo -e "35_pandrug_top_drug_sensitivity_comparison\n"
Rscript 36_pandrug_comparison_boxplot.R
echo -e "36_pandrug_comparison_boxplot\n"
