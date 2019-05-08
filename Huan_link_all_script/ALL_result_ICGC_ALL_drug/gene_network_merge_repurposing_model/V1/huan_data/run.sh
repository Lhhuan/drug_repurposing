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