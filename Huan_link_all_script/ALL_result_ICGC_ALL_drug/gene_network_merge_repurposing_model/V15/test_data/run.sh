perl 01_filter_drug_indication_as_cancer.pl #把"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt" 治疗cancer，且一行的indication中只有一个cancer的，并且是phase4或者Approved 的 drug cancer作为正样本。
#得./output/01_drug_cancer_indication.txt

perl 02_new_positive_and_nagetive.pl #把./output/01_drug_cancer_indication.txt 和"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/test_data/output/07_final_positive_and_negative.txt"
#中的负样本merge到一起，得./output/02_positive_negative_sample.txt





perl 08_merge_drug_name_data_for_logistic_regression.pl #把"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt" 中的Drug_chembl_id_Drug_claim_primary_name和Drug_claim_primary_name提出来，
#和../huan_data/output/06_merge_sub_main_features_for_logistic_regression.txt mergr 到一起，得./output/08_drug_primary_calculate_features_for_logistic_regression.txt 
perl 09_filter_test_data_for_logistic_regression.pl 
##从./output/08_drug_primary_calculate_features_for_logistic_regression.txt过滤出"./output/02_positive_negative_sample.txt"
#需要的feature，得./output/09_media_filter_test_data_for_logistic_regression.txt
#提取./output/09_media_filter_test_data_for_logistic_regression.txt中需要的feature，得 ./output/09_filter_test_data_for_logistic_regression_re.txt
# 后来发现./output/09_filter_test_data_for_logistic_regression_re.txt 中有的重复（drug cancer pair既是0，也是1，）,所以要把这些去掉,得./output/09_filter_test_data_for_logistic_regression.txt
Rscript 09_model_optimization.R #优化model
Rscript 10_test_logistic_regression_normal_model1.R #只用civic的数据做正样本。

perl 11_merge_all_training_dataset.pl #将./output/09_filter_test_data_for_logistic_regression.txt 和../validation/gdkb_cgi_oncokb_mtctscan/output/05_filter_mtctscan_use_to_validation_positive_prediction.txt
#merge 到一起，得./output/11_all_training_dataset.txt

Rscript 12_test_logistic_regression_normal_model2.R #用所有的actionable mutation的数据做正样本。