
#-----------------------------------------------------------------------
#--------------------------------------------------- 提feature
perl 02_filter_infos_for_calculate_feature_final.pl  #因为"/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/17_judge_the_shortest_drug_target_cancer_gene_logic_true.txt"文件太大，
#提取"/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/17_judge_the_shortest_drug_target_cancer_gene_logic_true.txt" 中部分列，用来计算feature，得./output/02_filter_infos_for_calculate_feature.txt
perl 03_calculate_for_network_based_repo_logistic_regression_data_final.pl # 用./output/02_filter_infos_for_calculate_feature.txt计算feature, 得./output/03_calculate_for_network_based_repo_logistic_regression_data.txt
