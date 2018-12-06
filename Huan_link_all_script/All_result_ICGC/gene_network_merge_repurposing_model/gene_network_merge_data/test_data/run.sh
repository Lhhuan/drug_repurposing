
perl 001_extract_drug_cancer_clinical_recruiting_pahse1_early_phase1.pl #把经过recruiting,not yet recruiting, active not recruiting,early phase1, phase1 cancer这些条件筛选后，
#得./output/SearchResults.tsv ,对./output/SearchResults.tsv 只选每个nctid只对应一个cancer的drug cancer pair.并根据"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"判断这个药物是否为cancer drug，
#得非cancer drug  对应的clincal trial drug cancer pairs文件 ./output/001_extract_drug_cancer_clinical_recruiting_pahse1_early_phase1.txt



#-----------------------------------------------------------------------------------------------------
perl 01_filter_original_gene_network_based_test_data.pl #把../../Gene-based_data/side_effect_repo_data/09_prepare_data_for_logistic_regression.txt 
#和"/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/test_data/output/01_drug_taregt_cancer_gene_differ.txt" 中提取出来，merge到一起，得./output/01_filter_original_gene_network_based_test_data.txt