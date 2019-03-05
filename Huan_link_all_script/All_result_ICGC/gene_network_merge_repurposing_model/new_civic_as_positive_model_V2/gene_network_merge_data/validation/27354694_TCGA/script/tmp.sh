perl 08_filter_cnv_in_huan.pl
echo -e "finish_08_filter_cnv_in_huan\n"
perl 09_calculate_features_for_logistic_regression.pl
echo -e "finish_09_calculate_features_for_logistic_regression\n"
Rscript 10_predict_TCGA_data.R
echo -e "finish_10_predict_TCGA_data\n"
perl 11_merge_prediction_and_icgc_result.pl
echo -e "finish_11_merge_prediction_and_icgc_result\n"