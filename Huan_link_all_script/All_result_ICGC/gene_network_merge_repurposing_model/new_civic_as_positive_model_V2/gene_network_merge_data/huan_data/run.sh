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
# perl 07_filter_icgc_data_features_for_logistic_regression.pl #用./output/04_final_data_for_calculate_features.txt中的sub oncotree id(没有sub的采用main，也就是相当于用sub那列)和 drug pair 提出 ./output/06_merge_sub_main_features_for_logistic_regression.txt中
# #的feature，得./output/07_filter_icgc_data_features_for_logistic_regression.txt
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
perl 15_split_drug_repurposing_and_drug_indication.pl # 把./output/14_merge_oncotree_main_detail_term.txt 中的indication和drug repurposing 分开，并把>=0.9的打上lable,得./output/15_drug_repurposing_recall_indication.txt 和./output/15_drug_potential_repurposing.txt

#------------------------------------------------------------------------------------------------为画图做准备，统计gene based 和network based 对应的 genetic based 统计。
#---------------------------------------------------------------没有对drug target数目设置限制, gene based 可以去top drug target统计，但是network based不可以，因为network是drug target group 作为整体走出来的
cat ./output/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt | cut -f11,12,13,14,16,20 | sort -u >./output/gene_based_logic_true_drug_cancer_pairs.txt
cat ./output/02_filter_network_based_infos.txt | cut -f1,2,15,16,17,18 > ./output/network_based_logic_true_drug_cancer_pairs.txt

perl count_gene_drug_in_cancer.pl #根据 ./output/gene_based_logic_true_drug_cancer_pairs.txt 计算logic true gene based 每个cancer对应了几个drug，以及总体的比例，main cancer 文件
#得./output/gene_based_logic_true_drug_count_in_main_cancer.txt detail 得./output/gene_based_logic_true_drug_count_in_detail_cancer.txt
perl count_network_drug_in_cancer.pl #根据 ./output/network_based_logic_true_drug_cancer_pairs.txt 计算logic true gene based 每个cancer对应了几个drug，以及总体的比例，main cancer 文件
#得./output/network_based_logic_true_drug_count_in_main_cancer.txt detail 得./output/network_based_logic_true_drug_count_in_detail_cancer.txt
Rscript gene_based_drug_proportion_test.R #为./output/gene_based_logic_true_drug_count_in_main_cancer.txt 和./output/gene_based_logic_true_drug_count_in_detail_cancer.txt 做proportion_test，分别得
#./output/gene_based_main_cancer_proportion_test.txt 和./output/gene_based_detail_cancer_proportion_test.txt
Rscript network_based_drug_proportion_test.R #为./output/network_based_logic_true_drug_count_in_main_cancer.txt 和./output/network_based_logic_true_drug_count_in_detail_cancer.txt 做proportion_test，分别得
#./output/network_based_main_cancer_proportion_test.txt 和./output/network_based_detail_cancer_proportion_test.txt
#---------------------------------------------------------------------------------------------------------------------------------------------------------- 
#-------------------------------------------------------------#取top的gene然后，然后看取drug cancer pairs
perl merge_gene_based_and_network_based_data_for_figure.pl #把./output/02_unique_filter_network_based_infos.txt 取特定列和
#./output/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt中取特定列merge到一起，得./output/merge_gene_based_and_network_based_data_for_figure.txt
#对./output/merge_gene_based_and_network_based_data_for_figure.txt 进行排序去重得 ./output/03_unique_merge_gene_based_and_network_based_data.txt
perl filter_top_gene_by_score.pl ##对于./output/merge_gene_based_and_network_based_data_for_figure.txt中的每个drug 按照drug target选出gene based 和network based 的top gene,得./output/filter_top_gene_by_score.txt
perl recall_top_gene_by_score_info.pl #对./output/filter_top_gene_by_score.txt 从./output/merge_gene_based_and_network_based_data_for_figure.txt中提取相关信息，得./output/recall_top_gene_by_score_info.txt
perl count_gene_drug_in_cancer_gene_top.pl # 统计./output/recall_top_gene_by_score_info.txt中gene based 和network based 中每种main cancer 和detail cancer 中 对应的drug 数目，分别得文件
#得./output/gene_based_logic_true_drug_count_in_main_cancer_gene_top.txt detail 得./output/gene_based_logic_true_drug_count_in_detail_cancer_gene_top.txt
#得./output/network_based_logic_true_drug_count_in_main_cancer_gene_top.txt detail 得./output/network_based_logic_true_drug_count_in_detail_cancer_gene_top.txt

Rscript gene_based_drug_proportion_test_top.R #为./output/gene_based_logic_true_drug_count_in_main_cancer_gene_top.txt 和./output/gene_based_logic_true_drug_count_in_detail_cancer_gene_top.txt 做proportion_test，分别得
#./output/gene_based_main_cancer_proportion_test_top.txt 和./output/gene_based_detail_cancer_proportion_test_top.txt

#最终用于画图的是 #./output/gene_based_main_cancer_proportion_test_top.txt 和./output/gene_based_detail_cancer_proportion_test_top.txt
#和#./output/network_based_main_cancer_proportion_test.txt 和./output/network_based_detail_cancer_proportion_test.txt