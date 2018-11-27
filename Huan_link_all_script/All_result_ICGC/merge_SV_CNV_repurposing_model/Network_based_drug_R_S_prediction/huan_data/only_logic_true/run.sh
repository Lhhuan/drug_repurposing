
#-----------------------------------------------------------------------
#--------------------------------------------------- 提feature
perl 02_filter_infos_for_calculate_feature_final.pl  #因为"/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt"文件太大，
#提取"/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/17_judge_the_shortest_drug_target_cancer_gene_logic_true.txt" 中不部分列，用来计算feature，得./output/02_filter_infos_for_calculate_feature.txt
perl 021_add_sv_and_cnv_info_for_calculate_feature.pl  #将"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel/pathogenic_hotspot/04_all_SV_and_CNV_pathogenic_hotspot_gene_oncotree.txt"
#和./output/02_filter_infos_for_calculate_feature.txt merge在一起，得./output/021_add_sv_and_cnv_info_for_calculate_feature.txt,并去重排序得文件./output/021_sorted_add_sv_and_cnv_info_for_calculate_feature.txt
perl 03_calculate_for_network_based_repo_logistic_regression_data_final.pl # 用./output/021_sorted_add_sv_and_cnv_info_for_calculate_feature.txt计算feature, 得./output/03_calculate_for_network_based_repo_logistic_regression_data.txt
Rscript 04_prediction_of_network_based_drug_repurposing_model.R #为./output/03_calculate_for_network_based_repo_logistic_regression_data.txt预测潜在的drug repurposing ,得./output/04_logistic_regression_prediction_potential_drug_repurposing_data.txt
perl 05_merge_drug_cancer_network_based_prediction_potential_drug_repurposing.pl #因为./output/04_logistic_regression_prediction_potential_drug_repurposing_data.txt中没有drug cancer 的信息，
#所以用./output/03_calculate_for_network_based_repo_logistic_regression_data.txt和./output/04_logistic_regression_prediction_potential_drug_repurposing_data.txt merge起来，
#并得到预测结果为repurposing 的文件./output/05_merge_drug_cancer_network_based_prediction_potential_drug_repurposing.txt
perl 06_merge_05_drug_indication.pl #将"/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt"中的indication和./output/05_merge_drug_cancer_network_based_prediction_potential_drug_repurposing.txt 
#merge 到一起，得./output/06_drug_cancer_network_based_prediction_potential_drug_repurposing_indication.txt
perl 07_judge_indication_and_cancer_differ.pl #判断./output/06_drug_cancer_network_based_prediction_potential_drug_repurposing_indication.txt中的indication和cancer是否相同，
#得indication和cancer相同文件./output/07_indication_and_cancer_same.txt ,得indication和cancer不相同文件./output/07_indication_and_cancer_differ.txt，
#并从./output/06_drug_cancer_network_based_prediction_potential_drug_repurposing_indication.txt中为./output/07_indication_and_cancer_differ.txt提取其他信息，得./output/07_indication_and_cancer_differ_info.txt
perl 08_filter_drug_status_unique_drug_repurposing.pl #因为./output/07_indication_and_cancer_differ_info.txt中同一个drug有不同status，
#在07中测试过，重复的药物状态中，所有药物的最大状态都是Launched，所以对于药物状态重复的，都保留launched,得./output/08_final_network_based_drug_repurposing_success.txt
