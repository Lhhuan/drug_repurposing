perl 01_merge_mtctscan_old_and_new.pl # 将./data/from_xinyi/mtctdb_all.txt 和./data/from_xinyi/mtctscan_20190107.txt 中提出validation需要的列 到一起，得./output/mtctscan_all_need_info.txt,
#从./output/mtctscan_all_need_info.txt中筛选std_implication_result 为 Increased sensitivity *的，得./output/mtctscan_all_need_info_only_sensitivity.txt,
#并得./output/mtctscan_all_need_info_only_sensitivity.txt 中的unique cancer term，得./output/mtctscan_all_need_info_only_sensitivity_uni_cancer.txt

#将./output/mtctscan_all_need_info_only_sensitivity_uni_cancer.txt map 到oncotree 得./output/mtctscan_all_need_info_only_sensitivity_uni_cancer_Oncotree.txt
perl  02_merge_mtctscan_all_sensitivity_oncotree.pl #将./output/mtctscan_all_need_info_only_sensitivity.txt和./output/mtctscan_all_need_info_only_sensitivity_uni_cancer_Oncotree.txt merge在一起，
#得./output/02_merge_mtctscan_all_sensitivity_oncotree.txt 
perl 03_fllter_mtctscan_cancer_gene_out_test_data.pl #筛选./output/02_merge_mtctscan_all_sensitivity_oncotree.txt 在../../test_data/output/09_media_filter_test_data_for_logistic_regression.txt中没有出现的，
#oncotree 非 NA的drug cancer 信息。得./output/03_fllter_mtctscan_cancer_gene_out_test_data.txt,
#得只有cancer 和drug的信息文件./output/03_fllter_mtctscan_cancer_gene_out_test_drug_cancer.txt
perl 04_filter_mtctscan_use_to_validation_positive.pl # 筛选在../../test_data/output/08_drug_primary_calculate_features_for_logistic_regression.txt中出现的./output/03_fllter_mtctscan_cancer_gene_out_test_data.txt，
#作为验证的正样本，得中间文件./output/04_filter_mtctscan_use_to_validation_positive_media.txt, 得最终文件./output/04_filter_mtctscan_use_to_validation_positive.txt