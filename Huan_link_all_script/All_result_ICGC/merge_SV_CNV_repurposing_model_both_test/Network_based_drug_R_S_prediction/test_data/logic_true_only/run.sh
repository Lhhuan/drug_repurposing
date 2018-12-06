perl 02_merge_drug_name_data_for_logistic_regression.pl #将"/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model/Network_based_drug_R_S_prediction/huan_data/only_logic_true/output/021_sorted_add_sv_and_cnv_info_for_calculate_feature.txt" 中的Drug_chembl_id_Drug_claim_primary_name和Drug_claim_primary_name提出来，
#和"/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model/Network_based_drug_R_S_prediction/huan_data/only_logic_true/output/03_calculate_for_network_based_repo_logistic_regression_data.txt" 通过Drug_chembl_id_Drug_claim_primary_name将Drug_claim_primary_name和"../huan_data/output/03_calculate_for_network_based_repo_logistic_regression_data.txt"
#得"./output/02_drug_primary_calculate_for_network_based_repo_logistic_regression_data.txt"
perl 03_filter_repo_withdrwal_data_for_logistic_regression.pl #根据"/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/test_data/output/01_drug_taregt_cancer_gene_differ.txt"中的drug cancer pair 在"./output/02_drug_primary_calculate_for_network_based_repo_logistic_regression_data.txt"
#中提取repo_or_withdrawl 的logistic_regression信息。得./output/03_filter_repo_withdrwal_data_for_logistic_regression.txt,并把repo和indication的值设为1，Withdrawn|Terminated设为0，得"./output/03_final_filter_repo_withdrwal_data_for_logistic_regression.txt"
perl 04_random_select_prediction_data_as_negative_sample.pl #随机选取../../huan_data/only_logic_true/output/031_calculate_for_network_based_repo_logistic_regression_data_final.txt 中的150个做作为负样本，得04_random_select_prediction_data_as_negative.txt

Rscript test_network_based_logistic_regression.R #预测并评估model