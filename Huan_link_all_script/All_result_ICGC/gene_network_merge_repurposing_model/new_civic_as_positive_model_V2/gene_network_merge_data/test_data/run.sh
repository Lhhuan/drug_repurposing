wget https://civicdb.org/downloads/nightly/nightly-ClinicalEvidenceSummaries.tsv  #源于civic #2018.12.10download
mv nightly-ClinicalEvidenceSummaries.tsv ./data/
perl 01_filter_Sensitivity_clinical_significance.pl #把./data/nightly-ClinicalEvidenceSummaries.tsv 中clinical_significan为Sensitivity的筛选出来，得./output/01_filter_Sensitivity_clinical_significance.txt
cat ./output/01_filter_Sensitivity_clinical_significance.txt | cut -f2 | sort -u >./output/unqie_cancer.txt
#将./output/unqie_cancer.txt map 到http://oncotree.mskcc.org/#/home oncotree的主干上，得./output/unqie_cancer_oncotree.txt
perl 02_merge_oncotree.pl #将./output/01_filter_Sensitivity_clinical_significance.txt和./output/unqie_cancer_oncotree.txt merge到一起，得./output/02_Sensitivity_clinical_significance_oncotree.txt
perl 03_filter_single_drug.pl #把./output/02_Sensitivity_clinical_significance_oncotree.txt中是药物联用的行去掉，得./output/03_single_drug_treat_cancer.txt,drug和 "/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"里的
#drug取overlap，得overlap 文件./output/03_unique_overlap_drug.txt。得没有overlap的文件，./output/03_unique_not_overlap_drug.txt ,并将./output/03_unique_not_overlap_drug.txt中的药物在dgidb中进行查询，
#得查询结果./output/03_unique_not_overlap_drug_refine.txt
cat ./output/03_unique_overlap_drug.txt ./output/03_unique_not_overlap_drug_refine.txt > ./output/03_unique_drug.txt
perl 04_filter_drug_in_huan_data.pl #检查在./output/03_unique_drug.txt的drug在"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"中存在，并调出./output/03_single_drug_treat_cancer.txt中的cancer信息，得./output/04_drug_cancer.txt
wget -c https://chiragjp.shinyapps.io/repoDB/_w_cb9d017f/session/93a20069a36c082a18d998e860304f87/download/downloadFull?w=cb9d017f #得repoDB_full.csv
mv repoDB_full.csv ./data/
perl 05_filter_cancer_from_repoDB.pl ##从repoDB_full.csv中筛出indication 为cancer的信息。得被Terminated_or_Withdrawn的cancer drug info文件./output/05_filter_cancer_from_repoDB_negative.txt
cat ./output/05_filter_cancer_from_repoDB_negative.txt | cut -f2 | sort -u >./output/05_uniqie_negative_cancer.txt 
#并将./output/05_uniqie_negative_cancer.txt map 到oncotree (http://oncotree.mskcc.org/#/home),得./output/05_uniqie_negative_cancer_oncotree.txt
perl 06_megre_negative_cancer_oncotree.pl ##将./output/05_uniqie_negative_cancer_oncotree.txt和./output/05_filter_cancer_from_repoDB_negative.txt merge到一起，得./output/06_megre_negative_cancer_oncotree.txt
perl 07_merge_positive_and_negative.pl #将./output/04_drug_cancer.txt和./output/06_megre_negative_cancer_oncotree.txt merge 在一起，得./output/07_merge_positive_and_negative.txt
#并将./output/07_merge_positive_and_negative.txt中的 drug cancer pair 中即对应positive又对应negative筛掉，得./output/07_final_positive_and_negative.txt
perl 08_merge_drug_name_data_for_logistic_regression.pl  #把"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt" 中的Drug_chembl_id_Drug_claim_primary_name和Drug_claim_primary_name提出来，
#和../huan_data/output/06_merge_sub_main_features_for_logistic_regression.txt mergr 到一起，得./output/08_drug_primary_calculate_features_for_logistic_regression.txt 
perl 09_filter_test_data_for_logistic_regression.pl #从./output/08_drug_primary_calculate_features_for_logistic_regression.txt过滤出./output/07_final_positive_and_negative.txt需要的feature，得./output/09_media_filter_test_data_for_logistic_regression.txt
#提取./output/09_media_filter_test_data_for_logistic_regression.txt中需要的feature，得 ./output/09_filter_test_data_for_logistic_regression.txt
Rscript 10_test_logistic_regression_normal.R