perl 01_merge_gene_based_and_network_based_data.pl #把../../Network_based_data/huan_data/only_logic_true/output/unique_02_filter_infos_for_calculate_feature.txt 取特定列和
#../../Gene-based_data/huan_data/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt中取特定列merge到一起，得./output/01_merge_gene_based_and_network_based_data.txt
#对./output/01_merge_gene_based_and_network_based_data.txt 进行排序去重得 ./output/01_unique_merge_gene_based_and_network_based_data.txt
perl 02_merge_drug_target_infos.pl #把"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt" 中的drug target 中提取出来，新生成一列，这一列有ensg 用ensg填充，没有ensg用entrez填充，没有entrez拿gene symbol填充。
#并和./output/01_unique_merge_gene_based_and_network_based_data.txt merge在一起，得"./output/02_extract_drug_target_gene_network_data.txt",并得drug target 文件./output/02_drug_target.txt
perl 03_merge_sv_cnv_gene_network_based.pl #把./output/02_extract_drug_target_gene_network_data.txt和"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/05_all_sv_cnv_oncotree.txt"
#merge在一起，得./output/03_final_data_for_calculate_features.txt
perl 04_calculate_features_for_logistic_regression.pl # 用./output/03_final_data_for_calculate_features.txt计算逻辑回归需要的features，得04_calculate_features_for_logistic_regression.txt