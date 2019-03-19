perl 01_filter_snv_in_huan.pl #用../TCGA_28847918/output/06_filter_snv_in_icgc.txt和../../huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt 取overlap得./output/01_filter_snv_in_huan.txt
#uniq 得./output/01_sorted_filter_snv_in_huan.txt
perl 02_calculate_features_for_logistic_regression.pl #用./output/01_sorted_filter_snv_in_huan.txt 和../TCGA_28847918/output/08_filter_cnv_in_huan.txt 计算用于用于model预测的feature ,得./output/02_calculate_features_for_logistic_regression.txt
less ./output/02_calculate_features_for_logistic_regression.txt | cut -f4 | sort -u | wc -l  #共 1917个samples
wc -l ./output/02_calculate_features_for_logistic_regression.txt #4227221 个pairs
Rscript 03_predict_repurposing.R #为./output/02_calculate_features_for_logistic_regression.txt 预测drug repurposing ,得./output/03_prediction_logistic_regression.txt
Rscript 04_sort_predict_value_by_sample.R #取出./output/03_prediction_logistic_regression.txt中每个sample repurposing value top1 的药物，得./output/04_sample_in_paper_top_repurposing_value.txt
perl 05_count_drug_number_in_sample.pl #统计./output/04_sample_in_paper_top_repurposing_value.txt 中predict_value >0.9的每个drug推荐的sample个数，得./output/05_count_drug_number_in_sample.txt
## 得 包含drug sample数目的drug cancer sample info得 ./output/05_count_drug_number_in_sample_info.txt #2488行
perl 06_merge_info_used_to_prediction_and_05_count_drug_number_sample.pl #
#为./output/05_count_drug_number_in_sample_info.txt 从./output/01_sorted_filter_snv_in_huan.txt和output/02_calculate_features_for_logistic_regression.txt提取出用于预测的信息，得
#./output/06_merge_info_used_to_prediction_and_05_count_drug_number_sample.txt
perl 07_extract_ICGC_mutation_id_HGVSg.pl #将"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1_vep.vcf"
#中的mutation id和HVSGg提取出来，得./output/07_ICGC_mutation_id_HGVSg.txt
perl 08_merge_top_number_drug_sample_mutation_hgvsg.pl #为./output/06_merge_info_used_to_prediction_and_05_count_drug_number_sample.txt 添加 HGVSg，
#得./output/08_merge_top_number_drug_sample_mutation_hgvsg.txt
perl 081_merge_Drug_claim_primary_name_top_number_drug_sample_mutation_hgvsg.pl # 把./output/08_merge_top_number_drug_sample_mutation_hgvsg.txt和 /f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt
#中的Drug_claim_primary_name merge 到一起，得./output/081_final_top_number_drug_sample_mutation_hgvsg.txt
perl 082_merge_Drug_top_number_drug_sample_mutation_hgvsg_cancer_term.pl  #将"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt" 中的cancer term和
# ./output/081_final_top_number_drug_sample_mutation_hgvsg.txt merge 到一起，得./output/082_merge_Drug_top_number_drug_sample_mutation_hgvsg_cancer_term.txt
#-------------------------------------------------------提取actionable mutation
#
perl 09_filter_civic_sensitivty.pl #此脚本是对../../test_data/01_filter_Sensitivity_clinical_significance.pl 的改进，因为相比于之前要加drug_interaction_type这列（因为要对两个药物的substance 进行拆分），所以重新跑
##把../../test_data/data/nightly-ClinicalEvidenceSummaries.tsv 中clinical_significan为Sensitivity的筛选出来，得./output/09_filter_Sensitivity_civic.txt
perl 10_civic_merge_oncotree.pl # 把./output/09_filter_Sensitivity_civic.txt 和../../test_data/output/unqie_cancer_oncotree.txt merge 到一起，得./output/10_civic_merge_oncotree.txt 
#这里是对../../test_data/02_merge_oncotree.pl 的改进
perl 11_deal_with_drug_by_drug_interaction_type.pl #根据drug_interaction type，对/output/10_civic_merge_oncotree.txt中的drug进行处理，得./output/11_civic_sensitivity_oncotree_deal_drug.txt
perl 12_merge_civic_and_mtctscan_other_database.pl # 把./output/11_civic_sensitivity_oncotree_deal_drug.txt 和../gdkb_cgi_oncokb_mtctscan/output/02_merge_mtctscan_all_sensitivity_oncotree.txt 中的非civic来源的sensitivity
#merge 到一起，得./output/12_merge_civic_and_mtctscan_other_database.txt
perl 13_transvar_ref_alt.pl #把区分./output/12_merge_civic_and_mtctscan_other_database.txt里面的突变类型是否可以用transvar 转换,得./output/13_transvar_ref_alt.txt
#此步中报错没有关系，表明不能为该位点不能用transvar转
perl 14_cancer_drug_specific_hit_actionable_mutation.pl #将./output/13_transvar_ref_alt.txt 和./output/082_merge_Drug_top_number_drug_sample_mutation_hgvsg_cancer_term.txt 通过cancer drug mutation merge 到一起，得
#hit 住的action mutation 文件得./output/14_cancer_drug_specific_hit_actionable_mutation.txt ,
##得potential 的actionable mutation 得文件./output/14_cancer_drug_specific_potential_actionable_mutation.txt
#得标注mutation 是否是actionable的文件./output/14_cancer_drug_specific_hit_actionable_or_not.txt

perl 15_pancancer_pandrug_hit_actionable_mutation.pl #将./output/13_transvar_ref_alt.txt 和./output/082_merge_Drug_top_number_drug_sample_mutation_hgvsg_cancer_term.txt 通过mutation merge 到一起，得
#hit 住的action mutation 文件得./output/15_pancancer_pandrug_hit_action_mutation.txt ,
##得potential 的actionable mutation 得文件./output/15_pancancer_pandrug_potential_mutation.txt
#得标注mutation 是否是actionable的文件./output/15_pancancer_pandrug_hit_actionable_or_not.txt
perl 16_count_actionable_mutation_percentage_in_per_drug.pl # 统计./output/15_pancancer_pandrug_hit_actionable_or_not.txt中每个drug 中出现的特定actionable_mutation的百分比 ,并从./output/05_count_drug_number_in_sample_info.txt 中
#获得药物hit 住的 Sample 数目得./output/16_count_actionable_mutation_percentage_in_per_drug.txt
perl 16_1_count_actionable_mutation_percentage_in_per_drug.pl # 统计./output/15_pancancer_pandrug_hit_actionable_or_not.txt中每个drug 中出现的特定actionable_mutation的百分比 ,并从./output/05_count_drug_number_in_sample_info.txt 中
#获得药物hit 住的 Sample 数目得./output/16_count_actionable_mutation_percentage_in_per_drug_simple.txt
cat ./output/15_pancancer_pandrug_hit_action_mutation.txt | cut -f39| sort -u >./output/final_hit_actionable_mutation.txt
cat ./output/15_pancancer_pandrug_potential_mutation.txt | cut -f38 |sort -u > ./output/final_poteinal_actionable_mutation.txt