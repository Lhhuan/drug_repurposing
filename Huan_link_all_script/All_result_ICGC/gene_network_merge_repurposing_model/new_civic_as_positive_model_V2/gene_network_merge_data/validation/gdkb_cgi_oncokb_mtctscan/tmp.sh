# perl 04_merge_mtctscan_chembl.pl
# echo -e "finish_04_merge_mtctscan_chembl\n"
perl 05_filter_out_mtctscan_test_in_huan.pl
echo -e "finish_05_filter_out_mtctscan_test_in_huan\n"
perl 06_random_select_9_fold_negative.pl
echo -e "finish_06_random_select_9_fold_negative\n"
perl 07_merge_negative_positive.pl
echo -e "finish_07_merge_negative_positive\n"
Rscript 08_sort_value_of_n_p.R
echo -e "finish_08_sort_value_of_n_p\n"
perl 09_number_of_positive_in_multi_top_ratio.pl
echo -e "finish_09_number_of_positive_in_multi_top_ratio\n"
Rscript 10_plot_number_of_positive_in_multi_top_ratio.R
echo -e "finish_10_plot_number_of_positive_in_multi_top_ratio\n"
# Rscript 11_plot_roc_for_p_n.R
# echo -e "finish_11_plot_roc_for_p_n\n"
perl 12_mark_positive_rwr.pl
echo -e "finish_12_mark_positive_rwr\n"
Rscript 13_exact_rwr_prediction_score_dis.R
echo -e "finish_exact_rwr_prediction_score_dis\n"




# perl 06_filter_snv_in_icgc.pl 
# echo -e "finish_06_filter_snv_in_icgc\n"