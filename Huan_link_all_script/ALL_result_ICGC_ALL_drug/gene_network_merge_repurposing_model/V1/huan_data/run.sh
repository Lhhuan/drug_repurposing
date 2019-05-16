perl 01_filter_gene_based_drug_cancer_mutation_info.pl #为 "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt"
#从"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_id_cadd_score.txt"提出mutation pathogenicity score，
#从"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt"提出drug target score，得./output/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt.gz
perl 02_filter_network_based_infos.pl ##因为"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt.gz"文件太大，
#提取"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt.gz"
#中不部分列，用来计算feature，得./output/02_filter_network_based_infos.txt.gz,并对./output/02_filter_network_based_infos.txt.gz进行去重得
#./output/02_unique_filter_network_based_infos.txt.gz
perl 03_merge_gene_based_and_network_based_data.pl #把./output/02_unique_filter_network_based_infos.txt.gz 取特定列和
#./output/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt.gz中取特定列merge到一起，得./output/03_merge_gene_based_and_network_based_data.txt.gz
#对./output/03_merge_gene_based_and_network_based_data.txt.gz 进行排序去重得 ./output/03_unique_merge_gene_based_and_network_based_data.txt.gz
perl 05_sub_calculate_features_for_logistic_regression.pl #
#用"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_SV_CNV/v4/output/all_pathogenicity_sv_snv.vcf"
# 用./output/03_unique_merge_gene_based_and_network_based_data.txt.gz和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/ICGC_sample_wgs_somatic/output/05_ICGC_pathogenicity_mutation_number_in_cancer_in_sample_level.txt"
#中的oncotree sub tissue ID 计算逻辑回归需要的features，得./output/05_sub_calculate_features_for_logistic_regression.txt
perl 05_main_calculate_features_for_logistic_regression.pl #
#用"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_SV_CNV/v4/output/all_pathogenicity_sv_snv.vcf"
# 用./output/03_unique_merge_gene_based_and_network_based_data.txt.gz和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/ICGC_sample_wgs_somatic/output/05_ICGC_pathogenicity_mutation_number_in_cancer_in_sample_level.txt"
#中的oncotree main tissue ID 计算逻辑回归需要的features，得./output/05_main_calculate_features_for_logistic_regression.txt
perl 06_merge_sub_main_features_for_logistic_regression.pl ##将./output/05_sub_calculate_features_for_logistic_regression.txt和./output/05_main_calculate_features_for_logistic_regression.txt merge 在一起，
#得./output/06_merge_sub_main_features_for_logistic_regression.txt
Rscript 08_prediction_drug_repurposing_normal.R #用model2 预测./output/06_merge_sub_main_features_for_logistic_regression.txt，得./output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt
perl 09_filter_training_dataset_repurposing_data.pl #将./output/08_logistic_regression_prediction_potential_drug_repurposing_data.txt中的../test_data/output/11_all_training_dataset.txt筛选出来
#得./output/09_training_dataset_repurposing_data.txt ,得没有训练集的预测数据文件./output/09_out_of_training_dataset_repurposing_data.txt
#--------
perl 10_merge_drug_claim_primary_name.pl ###利用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt" 给./output/09_out_of_training_dataset_repurposing_data.txt加一列Drug_claim_primary_name，
#得./output/10_repurposing_Drug_claim_primary_name.txt
perl 11_merge_drug_indication.pl ##将"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/21_all_drug_infos.txt"中的indication和./output/10_repurposing_Drug_claim_primary_name.txt merge 到一起，
#得 ./output/11_merge_drug_indication.txt
perl 12_merge_cancer_detail_main_ID.pl ##用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中的detail id 和 main id
#和./output/11_drug_unique_status_infos.txt(cancer) merge到一起，得./output/12_merge_cancer_detail_main_ID.txt #原来的$cancer_oncotree_id变成了$indication_OncoTree_detail_ID
perl 13_judge_indication_and_cancer_differ.pl ##判断./output/12_merge_cancer_detail_main_ID.txt中的indication和cancer是否相同，
#得indication和cancer相同文件./output/13_indication_and_cancer_same.txt ,得indication和cancer不相同文件./output/13_indication_and_cancer_differ.txt，#得加标签的原文件./output/13_indication_and_cancer_lable.txt
#并从./output/12_merge_cancer_detail_main_ID.txt中提取./output/13_indication_and_cancer_lable.txt的信息，得./output/13_indication_and_cancer_lable_info.txt
perl 14.1_merge_indication_and_cancer_lable.pl #将./output/09_out_of_training_dataset_repurposing_data.txt 和 ./output/13_indication_and_cancer_lable.txt merge到一起，得./output/14_09_out_of_training_dataset_repurposing_label.txt
perl 14_merge_oncotree_main_detail_term.pl ##用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中的detail oncotree term 和 oncotree term 和 ./output/13_indication_and_cancer_lable_info.txt
# merge 到一起，得./output/14_merge_oncotree_main_detail_term.txt
perl 15_split_drug_repurposing_and_drug_indication.pl ## 把./output/14_merge_oncotree_main_detail_term.txt 中的indication和drug repurposing 分开，并把>=0.9的打上lable,
#得./output/15_drug_repurposing_recall_indication.txt 和./output/15_drug_potential_repurposing.txt