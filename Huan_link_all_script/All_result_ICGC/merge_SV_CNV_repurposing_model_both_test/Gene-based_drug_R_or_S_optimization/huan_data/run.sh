perl 01_filter_gene_based_drug_cancer_mutation_info.pl #为 "/f/mulinlab/huan/All_result_ICGC/19_gene_based_ICGC_somatic_repo_may_success_logic.txt"
#从"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/cadd_score/SNV_Indel_cadd_score.vcf"提出mutation pathogenicity score，
#从"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"提出drug target score，得01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt
perl 02_filter_data_for_calculate_logistic_regression_data.pl #用01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt输出用于计算出logistic_regression需要的data的数据，02_data_used_calculate_for_repo_logistic_regression.txt
perl 021_add_CNV_dup_del_info_for_calculate_feature.pl #将"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt"
#和./02_data_used_calculate_for_repo_logistic_regression.txt merge在一起，得./output/021_add_CNV_dup_del_info_for_calculate_feature.txt,并去重排序得文件./output/021_sorted_add_CNV_dup_del_info_for_calculate_feature.txt
perl 021_calculate_average_tra_inv.pl #将"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt"
#和./02_data_used_calculate_for_repo_logistic_regression.txt merge在一起，计算drug cancer pair 中的cancer gene在inv_tra中的average gene,得文件./output/021_drug_cancer_pair_average_gene_in_inv_tra.txt,
#并得drug cancer pair 中的cancer gene在存在的具体hotspot，及和具体Hotspot的那个gene 有overlap,得文件"./output/021_drug_cancer_pair_in_inv_tra.txt"
perl 022_calculate_for_repo_logistic_regression_CNV_dup_del_data.pl #用./output/021_sorted_add_CNV_dup_del_info_for_calculate_feature.txt计算得用于逻辑回归模型预测的文件"./output/022_calculate_for_repo_logistic_regression_CNV_dup_del_data.txt"
perl 023_merge_gene_based_repo_logistic_regression_data_SV.pl #将./output/021_drug_cancer_pair_average_gene_in_inv_tra.txt和"./output/022_calculate_for_repo_logistic_regression_CNV_dup_del_data.txt" merge 在一起，
#得./output/023_calculate_for_gene_based_repo_logistic_regression_data_final.txt

#prediction_repurposing.txt  用"/f/mulinlab/huan/All_result_ICGC/Gene-based_drug_R_or_S_optimization/side_effect_repo_data/repo_cancer_model.R"预测得到。
perl 03_merge_drug_cancer_prediction_repurposing.pl #因为prediction_repurposing.txt中没有drug cancer 的信息，所以用./output/023_calculate_for_gene_based_repo_logistic_regression_data_final.txt和prediction_repurposing.txt merge起来，得到./output/03_drug_cancer_prediction_repurposing.txt
#并得到预测结果为repurposing 的文件./output/03_drug_cancer_prediction_repurposing_true.txt
perl 04_merge_03_drug_indication.pl ##将"/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt"中的indication和03_drug_cancer_prediction_repurposing_true.txt 
#merge 到一起，得./output/04_drug_cancer_gene_based_prediction_potential_drug_repurposing_indication.txt
perl 05_judge_indication_and_cancer_differ.pl ##判断"./output/04_drug_cancer_gene_based_prediction_potential_drug_repurposing_indication.txt"中的indication和cancer是否相同，
#得indication和cancer相同文件./output/05_indication_and_cancer_same.txt ,得indication和cancer不相同文件./output/05_indication_and_cancer_differ.txt，
#并从"./output/04_drug_cancer_gene_based_prediction_potential_drug_repurposing_indication.txt"中为./output/05_indication_and_cancer_differ.txt提取其他信息，得./output/05_indication_and_cancer_differ_info.txt
perl 06_filter_drug_status_unique_drug_repurposing.pl ##因为./output/05_indication_and_cancer_differ_info.txt中同一个drug有不同status，
#在07中测试过，重复的药物状态中，所有药物的最大状态都是Launched，所以对于药物状态重复的，都保留launched,得"./output/06_final_gene_based_drug_repurposing_success.txt"