
perl 001_extract_drug_cancer_clinical_recruiting_pahse1_early_phase1.pl #把经过recruiting,not yet recruiting, active not recruiting,early phase1, phase1 cancer这些条件筛选后，
#得./output/SearchResults.tsv ,对./output/SearchResults.tsv 只选每个nctid只对应一个cancer的drug cancer pair.并根据"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"判断这个药物是否为cancer drug，
#得非cancer drug  对应的clincal trial drug cancer pairs文件 ./output/001_extract_drug_cancer_clinical_recruiting_pahse1_early_phase1.txt
cat ./output/001_extract_drug_cancer_clinical_recruiting_pahse1_early_phase1.txt | cut -f2 | sort -u > ./output/unique_early_phase1_cancer.txt
#用 http://oncotree.mskcc.org/#/home 为./output/unique_early_phase1_cancer.txt 找出oncotree_main_tissue_ID ，得文件./output/unique_early_phase1_cancer_oncotree.txt
perl 002_merge_new_sample_cancer_oncotree.pl # 把./output/unique_early_phase1_cancer_oncotree.txt和./output/001_extract_drug_cancer_clinical_recruiting_pahse1_early_phase1.txt merge在一起，
#得./output/002_merge_new_negetive_sample_cancer_oncotree.txt


#-----------------------------------------------------------------------------------------------------
perl 01_filter_original_gene_network_based_test_data.pl #把../../Gene-based_data/side_effect_repo_data/09_prepare_data_for_logistic_regression.txt 
#和"/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/test_data/output/01_drug_taregt_cancer_gene_differ.txt" ,
#./output/002_merge_new_negetive_sample_cancer_oncotree.txt 中提取出来，merge到一起，得./output/01_filter_original_gene_network_based_test_data.txt
#将./output/01_filter_original_gene_network_based_test_data.txt中同一drug cancer pair对应两种drug_cancer_type_id 的去掉，得./output/01_final_filter_original_gene_network_based_test_data.txt
perl 02_merge_drug_name_data_for_logistic_regression.pl #把"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt" 中的Drug_chembl_id_Drug_claim_primary_name和Drug_claim_primary_name提出来，
#和../huan_data/output/04_calculate_features_for_logistic_regression.txt mergr 到一起，得./output/02_drug_primary_calculate_features_for_logistic_regression.txt 
perl 03_filter_test_data_for_logistic_regression.pl #从./output/02_drug_primary_calculate_features_for_logistic_regression.txt过滤出./output/01_final_filter_original_gene_network_based_test_data.txt
#需要的feature，得 ./output/03_filter_test_data_for_logistic_regression.txt
Rscript 04_test_logistic_regression.R #测试model
Rscript 04_test_logistic_regression_normal.R  #是将数据归一化后训练model

Rscript picture_features.R #为./output/03_filter_test_data_for_logistic_regression.txt画图