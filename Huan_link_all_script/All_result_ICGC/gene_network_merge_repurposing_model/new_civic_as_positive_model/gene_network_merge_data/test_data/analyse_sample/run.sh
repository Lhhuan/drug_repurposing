perl 01_filter_sample_drug_info.pl #筛选../output/09_filter_test_data_for_logistic_regression.txt 中在"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"中的信息，
#得./output/01_filter_sample_drug_info.txt
perl 02_statistics_drug_fda_approval_and_indication_cancer.pl #统计./output/01_filter_sample_drug_info.txt中药物的fda 和indication 是否为cancer,得./output/02_statistics_drug_fda_approval_and_indication_cancer.txt,然后为其添加Drug_claim_primary_name，
#得./output/02_statistics_drug_fda_approval_and_indication_cancer_final.txt
perl 03_select_cancer_phase_than0.pl #将./output/02_statistics_drug_fda_approval_and_indication_cancer_final.txt中indication是cancer，并且max phase>0的筛选出来，得./output/03_select_cancer_phase_than0.txt,
#并对../output/09_filter_test_data_for_logistic_regression.txt 进行筛选，得../output/04_filter_features_cancer_phase_than0.txt
