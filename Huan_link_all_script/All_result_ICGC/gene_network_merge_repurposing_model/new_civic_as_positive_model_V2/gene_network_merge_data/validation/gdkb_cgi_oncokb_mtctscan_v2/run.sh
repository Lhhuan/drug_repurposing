perl 01_merge_mtctscan_old_and_new.pl # 将./data/from_xinyi/mtctdb_all.txt 和./data/from_xinyi/mtctscan_20190107.txt 中提出validation需要的列 到一起，得./output/mtctscan_all_need_info.txt,
#从./output/mtctscan_all_need_info.txt中筛选std_implication_result 为 Increased sensitivity *的，得./output/mtctscan_all_need_info_only_sensitivity.txt,
#并得./output/mtctscan_all_need_info_only_sensitivity.txt 中的unique cancer term，得./output/mtctscan_all_need_info_only_sensitivity_uni_cancer.txt

#将./output/mtctscan_all_need_info_only_sensitivity_uni_cancer.txt map 到oncotree 得./output/mtctscan_all_need_info_only_sensitivity_uni_cancer_Oncotree.txt
perl  02_merge_mtctscan_all_sensitivity_oncotree.pl #将./output/mtctscan_all_need_info_only_sensitivity.txt和./output/mtctscan_all_need_info_only_sensitivity_uni_cancer_Oncotree.txt merge在一起，
#得./output/02_merge_mtctscan_all_sensitivity_oncotree.txt 
    # perl 03_fllter_mtctscan_cancer_gene_out_test_data.pl #筛选./output/02_merge_mtctscan_all_sensitivity_oncotree.txt 在../../test_data/output/09_media_filter_test_data_for_logistic_regression.txt中没有出现的，
    # #oncotree 非 NA的drug cancer 信息。得./output/03_fllter_mtctscan_cancer_gene_out_test_data.txt,
    # #得只有cancer 和drug的信息文件./output/03_fllter_mtctscan_cancer_gene_out_test_drug_cancer.txt
perl 04_merge_mtctscan_chembl.pl ## 筛选在../../test_data/output/08_drug_primary_calculate_features_for_logistic_regression.txt中出现的./output/02_merge_mtctscan_all_sensitivity_oncotree.txt"，
#得./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl_claim.txt",把./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl_claim.txt" 中的drug claim primary name去掉
#得./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl.txt，得mtctscan信息文件得./output/04_in_huan_mtctscan_ori.txt
perl 05_filter_out_mtctscan_test_in_huan.pl #将没有出现在./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl.txt和../../test_data/output/09_filter_test_data_for_logistic_regression.txt 中的
#../../huan_data/output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt 的drug cancer pair信息抽出来，得./output/05_filter_out_mtctscan_out_test_in_huan.txt
#得在./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl.txt中出现的drug cancer pair,但不在../../test_data/output/09_filter_test_data_for_logistic_regression.txt的
#文件./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt
perl 06_random_select_9_fold_negative.pl #从./output/05_filter_out_mtctscan_out_test_in_huan.txt 中选出9倍数目的./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt
#得./output/06_random_select_9_fold_negative.txt
perl 07_merge_negative_positive.pl #把./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt 和./output/06_random_select_9_fold_negative.txt merge在一起，得./output/07_merge_negative_positive.txt
Rscript 08_sort_value_of_n_p.R #对./output/07_merge_negative_positive.txt 按照prediction value 排序得./output/07_sorted_merge_negative_positive.txt
perl 09_number_of_positive_in_multi_top_ratio.pl #取不同的./output/07_sorted_merge_negative_positive.txt top ratio，看number_of_positive，得文件./output/09_number_of_positive_in_multi_top_ratio.txt
Rscript 10_plot_number_of_positive_in_multi_top_ratio.R #用./output/09_number_of_positive_in_multi_top_ratio.txt 做图。
Rscript 11_plot_roc_for_p_n.R #为./output/07_merge_negative_positive.txt 画ROC曲线
#-------------------------------------------------------------------------------#查看./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt 中是否是直接的rwr ，并画图
perl 12_mark_positive_rwr.pl #查看./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt 中是否是直接的rwr,得./output/12_mark_positive_rwr.txt
Rscript 13_exact_rwr_prediction_score_dis.R