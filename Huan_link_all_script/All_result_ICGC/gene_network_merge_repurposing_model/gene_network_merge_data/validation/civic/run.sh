wget https://civicdb.org/downloads/nightly/nightly-ClinicalEvidenceSummaries.tsv
mv nightly-ClinicalEvidenceSummaries.tsv ./data/
perl 01_filter_Sensitivity_clinical_significance.pl #把./data/nightly-ClinicalEvidenceSummaries.tsv 中clinical_significan为Sensitivity的筛选出来，得./output/01_filter_Sensitivity_clinical_significance.txt
cat ./output/01_filter_Sensitivity_clinical_significance.txt | cut -f2 | sort -u >./output/unqie_cancer.txt
#将./output/unqie_cancer.txt map 到http://oncotree.mskcc.org/#/home oncotree的主干上，得./output/unqie_cancer_oncotree.txt
perl 02_merge_oncotree.pl #将./output/01_filter_Sensitivity_clinical_significance.txt和./output/unqie_cancer_oncotree.txt merge到一起，得./output/02_Sensitivity_clinical_significance_oncotree.txt
perl 03_flter_huan_prediction_in_Sensitivity.pl #查找在./output/02_Sensitivity_clinical_significance_oncotree.txt中出现的../huan_data/output/10_final_full_drug_repurposing_success.txt ，
#得./overlap_with_huan_data/03_huan_prediction_data_overlap_Sensitivity.txt
#得unique的overlap drug cancer pair 是./overlap_with_huan_data/03_unique_huan_prediction_data_overlap_Sensitivity.txt，
##huan_data 中可以与./output/02_Sensitivity_clinical_significance_oncotree.txt中有overlap的drug文件"./overlap_with_huan_data/03_huan_prediction_sensitivity_drug.txt"
perl 04_filter_transvar_type.pl #根据是否明确说明是ref 和alt变异进行对./output/02_Sensitivity_clinical_significance_oncotree.txt筛选，得有SV文件./output/04_SV.txt,
#得到transvar可以转换的文件./output/04_used_to_transvar.txt
#用transvar 对./output/04_used_to_transvar.txt中的variant进行转换，得./output/04_transvar_unknown_ref_alt.txt
perl 05_merge_transvar.pl #将./output/04_used_to_transvar.txt和./output/04_transvar_unknown_ref_alt.txt merge在一起 合成一个文件，得./output/05_merge_transvar_result.txt
perl 06_extract_ICGC_mutation_id_HVSGg.pl #将"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1_vep.vcf"
#中的mutation id和HVSGg提取出来，得./output/ICGC_mutation_id_HVSGg.txt
perl 07_filter_mutation_in_ICGC.pl #从./output/ICGC_mutation_id_HVSGg.txt中筛选./output/05_merge_transvar_result.txt中的mutation，得./output/07_filter_mutation_in_ICGC.txt,
#并提取unique的mutation cancer drug pair 得文件./output/07_unique_mutation_drug_cancer_pair.txt
perl 08_unique_07_info_merge_drug_chembl.pl #利用"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt" 给./output/07_unique_mutation_drug_cancer_pair.txt和加一列Drug_chembl,
#./output/08_unique_mutation_Drug_chembl_cancer_pair.txt
perl 09_filter_mutation_drug_cancer_pair_in_huan_data.pl #从../../huan_data/output/03_final_data_for_calculate_features.txt中提取./output/08_unique_mutation_Drug_chembl_cancer_pair.txt 中的mutation_cancer_drug pair 
#得./output/09_validation_data_for_calculate_features.txt 
perl 10_calculate_features_for_logistic_regression.pl ## 用./output/09_validation_data_for_calculate_features.txt计算逻辑回归需要的features，得./output/10_calculate_features_for_logistic_regression.txt 
Rscript 11_validation_drug_repurposing.R #用model预测./output/10_calculate_features_for_logistic_regression.txt，得./output/11_validation_drug_repurposing_result.txt