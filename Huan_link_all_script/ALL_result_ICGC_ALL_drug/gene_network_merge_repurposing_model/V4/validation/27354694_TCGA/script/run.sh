perl 04_test_sample_drug_in_huan_data.pl #检测../data/table_s2.txt中的drug 和"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt"中drug的overlap,
#得overlap的drug文件./output/04_overlap_drug.txt,及其sample信息得../output/04_overlap_drug_sample_infos.txt，得没有overlap 的drug文件../output/04_no_overlap_drug.txt
perl 05_filter_04_overlap_drug_sample_info.pl  #把../output/04_overlap_drug_sample_infos.txt和
#"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/output/02_all_project_cnv.txt"，
#"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/output/02_all_project_snv.txt"，分别取overlap,
#得../output/05_28847918_cnv.txt和../output/05_28847918_snv.txt  #可以看到，这得到的这两个文件都是hg19的
perl 06_filter_snv_in_pathogenicity_icgc.pl ##用../output/05_28847918_snv.txt 和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_mutation_postion.txt"
#取overlap得../output/06_filter_snv_in_pathogenicity_icgc.txt
perl 06_count_sample_pathogenicity_mutation_number.pl #统计../output/05_28847918_snv.txt中每个sample 的pathogenicity mutation的数目，得../output/06_sample_pathogenicity_mutation_number.txt
perl 07_filter_snv_in_huan.pl #用../output/06_filter_snv_in_pathogenicity_icgc.txt和../../../huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt.gz 取overlap得../output/07_filter_snv_in_huan.txt
perl 071_QC_sample_snv.pl #将../output/07_filter_snv_in_huan.txt drug-cancer pair中的snv 数目小于X的过滤掉，得../output/071_filter_snv_in_huan.txt
perl 08_filter_cnv_in_huan.pl ## 用../output/05_28847918_cnv.txt和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_SV_CNV/v4/output/all_pathogenicity_sv_snv_oncotree.vcf"
#做overlap,得../output/08_filter_cnv_in_huan.txt
perl 09_calculate_features_for_logistic_regression.pl #计算逻辑回归需要的特征，得../output/09_calculate_features_for_logistic_regression.txt
Rscript 10_predict_TCGA_data.R 
perl 11_merge_prediction_and_icgc_result.pl #把../output/10_prediction_logistic_regression.txt和../output/04_overlap_drug_sample_infos.txt merge 到一起，得../output/11_prediction_and_icgc_result.txt
Rscript 12_plot_roc_for_11.R

