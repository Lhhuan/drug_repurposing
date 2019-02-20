perl 01_filter_gene_based_drug_cancer_mutation_info.pl ##为 "/f/mulinlab/huan/All_result_ICGC/19_gene_based_ICGC_somatic_repo_may_success_logic.txt"
#从"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/cadd_score/SNV_Indel_cadd_score.vcf"提出mutation pathogenicity score，
#从"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"提出drug target score，得./output/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt
perl 02_filter_network_based_infos.pl #因为"/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt"文件太大，
#提取"/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt"
#中不部分列，用来计算feature，得./output/02_filter_network_based_infos.txt,并对./output/02_filter_network_based_infos.txt进行去重得
#./output/02_unique_filter_network_based_infos.txt
perl 03_merge_gene_based_and_network_based_data.pl #把./output/02_unique_filter_network_based_infos.txt 取特定列和
#./output/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt中取特定列merge到一起，得./output/03_merge_gene_based_and_network_based_data.txt
#对./output/03_merge_gene_based_and_network_based_data.txt 进行排序去重得 ./output/03_unique_merge_gene_based_and_network_based_data.txt
# perl 04_merge_sv_cnv_gene_network_based.pl ##把./output/03_unique_merge_gene_based_and_network_based_data.txt和"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/05_all_sv_cnv_oncotree.txt"
#merge在一起，得./output/04_final_data_for_calculate_features.txt
perl 05_sub_calculate_features_for_logistic_regression.pl 
#用/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/05_merge_all_cnv_sv_project.txt
# 用./output/03_unique_merge_gene_based_and_network_based_data.txt中的oncotree sub tissue ID 计算逻辑回归需要的features，得./output/05_sub_calculate_features_for_logistic_regression.txt
perl 05_main_calculate_features_for_logistic_regression.pl
#用/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/05_merge_all_cnv_sv_project.txt
# 用./output/03_unique_merge_gene_based_and_network_based_data.txt和中的oncotree main tissue ID 计算逻辑回归需要的features，得./output/05_main_calculate_features_for_logistic_regression.txt
perl 06_merge_sub_main_features_for_logistic_regression.pl ##将./output/05_sub_calculate_features_for_logistic_regression.txt和./output/05_main_calculate_features_for_logistic_regression.txt merge 在一起，
#得./output/06_merge_sub_main_features_for_logistic_regression.txt
#./output/06_merge_sub_main_features_for_logistic_regression.txt 是计算出所以的sub和main tissue的features 可以供用户查询时提供的data 
perl 07_filter_icgc_data_features_for_logistic_regression.pl #用./output/04_final_data_for_calculate_features.txt中的sub oncotree id(没有sub的采用main，也就是相当于用sub那列)和 drug pair 提出 ./output/06_merge_sub_main_features_for_logistic_regression.txt中
#的feature，得./output/07_filter_icgc_data_features_for_logistic_regression.txt
Rscript 08_prediction_drug_repurposing_normal.R #预测./output/07_filter_icgc_data_features_for_logistic_regression.txt的repurposing 结果，得./output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt
perl 09_repurposing_Drug_claim_primary_name.pl #给./output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt加一列Drug_claim_primary_name，得./output/09_repurposing_Drug_claim_primary_name.txt
perl 10_merge_drug_indication.pl #将"/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt"中的indication和./output/09_repurposing_Drug_claim_primary_name.txt merge 到一起，
#得 ./output/10_merge_drug_indication.txt
perl 11_filter_drug_unique_status.pl #提取./output/10_merge_drug_indication.txt 中的unique的status,得./output/11_drug_unique_status.txt 并得附加其他信息的文件./output/11_drug_unique_status_infos.txt
perl 12_merge_cancer_detail_main_ID.pl #用"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中的detail id 和 main id
#和./output/11_drug_unique_status_infos.txt merge到一起，得./output/12_merge_cancer_detail_main_ID.txt #原来的$cancer_oncotree_id变成了$indication_OncoTree_detail_ID
perl 13_judge_indication_and_cancer_differ.pl #判断./output/12_merge_cancer_detail_main_ID.txt中的indication和cancer是否相同，
#得indication和cancer相同文件./output/13_indication_and_cancer_same.txt ,得indication和cancer不相同文件./output/13_indication_and_cancer_differ.txt，#得加标签的原文件./output/13_indication_and_cancer_lable.txt
#并从./output/12_merge_cancer_detail_main_ID.txt中提取./output/13_indication_and_cancer_lable.txt的信息，得./output/13_indication_and_cancer_lable_info.txt
#13_judge_indication_and_cancer_differ_01.pl +13_judge_indication_and_cancer_differ_02.pl 和13_judge_indication_and_cancer_differ.pl 的作用是一样的
perl 14_merge_oncotree_main_detail_term.pl # #用"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中的detail oncotree term 和 oncotree term 和 ./output/13_indication_and_cancer_lable_info.txt
# merge 到一起，得./output/14_merge_oncotree_main_detail_term.txt
perl 15_split_drug_repurposing_and_drug_indication.pl # 把./output/14_merge_oncotree_main_detail_term.txt 中的indication和drug repurposing 分开，并把>=0.9的打上lable,得15_drug_repurposing_repeat_indication.txt 和15_drug_repurposing.txt