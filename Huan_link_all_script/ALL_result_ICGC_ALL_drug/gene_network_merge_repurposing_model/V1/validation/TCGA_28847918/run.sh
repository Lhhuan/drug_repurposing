perl 04_test_sample_drug_in_huan_data.pl #检测"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/output/28847918_normal_type.txt"
#中的drug 和"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt""中drug的overlap,
#得overlap的drug文件./output/04_overlap_drug.txt,及其sample信息得./output/04_overlap_drug_sample_infos.txt，得没有overlap 的drug文件./output/04_no_overlap_drug.txt
perl 041_filter_gdsc_drug_wtih_04_no.pl ##用./output/04_no_overlap_drug.txt 提取
#"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/data/Drug_list_gdsc_11_55_50 2019.tsv"中的信息，;
#和gdsc有交集 文件./output/041_overlap_drug.txt
##和gdsc没有交集"./output/041_no_overlap.txt"
#和gdsc有交集，和huan有交集 "./output/041_overlap_huan.txt"
#和gdsc有交集，和huan没有交集 "./output/041_no_overlap_huan.txt"
#得最终和huan 没有overlap的文件./output/04_final_no_overlap_data.txt
perl 042_filter_sample.pl ##用"./output/041_overlap_huan.txt 取"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/output/28847918_normal_type.txt"
#中的信息，得./output/042_overlap_drug_sample_infos.txt
#./output/042_overlap_drug_sample_infos.txt 与./output/04_overlap_drug_sample_infos.txt 合并得最终./output/04_overlap_drug_sample_infos_final.txt #93个drug
perl 05_filter_04_overlap_drug_sample_info.pl #把./output/04_overlap_drug_sample_infos_final.txt和"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/output/02_all_project_cnv.txt"
#"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/output/02_all_project_snv.txt"，分布取overlap,
#得./output/05_28847918_cnv.txt和./output/05_28847918_snv.txt  #可以看到，这得到的这两个文件都是hg19的
perl 06_filter_snv_in_pathogenicity_icgc.pl ##用/output/05_28847918_snv.txt 和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_mutation_postion.txt"
#取overlap得./output/06_filter_snv_in_p_icgc.txt
perl 06_count_sample_pathogenicity_mutation_number.pl #统计../output/06_filter_snv_in_p_icgc.txt中每个sample 的pathogenicity mutation的数目，得../output/06_sample_pathogenicity_mutation_number.txt
perl 07_filter_snv_in_huan.pl #用./output/06_filter_snv_in_p_icgc.txt和"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt.gz"
#得./output/07_filter_snv_in_huan.txt
perl 08_filter_cnv_in_huan.pl # 用./output/05_28847918_cnv.txt和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt"
#做overlap,得./output/08_filter_cnv_in_huan.txt
perl 09_calculate_features_for_logistic_regression.pl ##用./output/07_filter_snv_in_huan.txt 和./output/08_filter_cnv_in_huan.txt 计算用于用于model预测的feature ,得./output/09_calculate_features_for_logistic_regression.txt
Rscript 10_predict_TCGA_data.R #用model2预测./output/09_calculate_features_for_logistic_regression.txt ，得./output/10_prediction_logistic_regression.txt
perl 11_merge_prediction_and_icgc_result.pl #把./output/10_prediction_logistic_regression.txt和"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/output/28847918_normal_type.txt"
# merge 到一起，得./output/11_prediction_and_icgc_result.txt
#----------------------------------------------------------------------------------------------------#将drug 的prediction value 分成top 0_0.1, 0.1_0.2,0.2_0.3,0.3_0.7,0.7_0.8,0.8_0.9,0.9_1.0共7组做比较,分别得文件./output/15_pandrug_top_${top}_${buttom}.txt
    perl 15_refine_pandrug_top_drug_sensitivity_comparison.pl
    Rscript 16_pandrug_comparison_boxplot.R #为./output/15_pandrug_top_${top}_${buttom}.txt画图
#--------------------------------------------------------------------------------#将drug 的prediction value 分成top 0_0.1, 0.1_0.2,0.2_0.8,0.8_0.9,0.9_1.0共5组做比较,分别得文件./output/17_pandrug_top_${top}_${buttom}.txt
    perl 17_pandrug_top_drug_sensitivity_comparison.pl 
    Rscript 18_pandrug_comparison_boxplot.R #为./output/17_pandrug_top_${top}_${buttom}.txt画图
#-------------------------------------------------------------------------------------------#将drug 的prediction value 分成top 0_0.1, 0.2_0.9,0.9_1.0共3组做比较,分别得文件./output/19_pandrug_top_${top}_${buttom}.txt
    perl 19_pandrug_top_drug_sensitivity_comparison.pl 
    Rscript 20_pandrug_comparison_boxplot.R #为./output/19_pandrug_top_${top}_${buttom}.txt画图
#-------------------------------------------------------------------------------------------#将drug 的prediction value 分成top 0_0.2, 0.2_0.8,0.8_1.0共3组做比较,分别得文件./output/21_pandrug_top_${top}_${buttom}.txt
    perl 21_pandrug_top_drug_sensitivity_comparison.pl 
    Rscript 22_pandrug_comparison_boxplot.R #为./output/21_pandrug_top_${top}_${buttom}.txt画图
#-------------------------------------------------------------------------------------------#将drug 的prediction value 分成top 0_0.15, 0.0.15_0.85,0.85_1.0共3组做比较,分别得文件./output/23_pandrug_top_${top}_${buttom}.txt
    perl 23_pandrug_top_drug_sensitivity_comparison.pl
    Rscript 24_pandrug_comparison_boxplot.R #为./output/23_pandrug_top_${top}_${buttom}.txt画图
#-------------------------------------------------------------------------------------------#将drug 的prediction value 分成top 0_0.25, 0.25_0.75,0.75_1共3组做比较,分别得文件./output/25_pandrug_top_${top}_${buttom}.txt
    perl 25_pandrug_top_drug_sensitivity_comparison.pl
    Rscript 26_pandrug_comparison_boxplot.R #为./output/25_pandrug_top_${top}_${buttom}.txt画图
#-------------------------------------------------------------------------------------------#将drug 的prediction value 分成top 0_0.3, 0.3_0.7,0.7_1共3组做比较,分别得文件./output/27_pandrug_top_${top}_${buttom}.txt
    perl 27_pandrug_top_drug_sensitivity_comparison.pl
    Rscript 28_pandrug_comparison_boxplot.R #为./output/27_pandrug_top_${top}_${buttom}.txt画图
#----------------------------------------------------------------------------将drug的predict value 分成top 0_0.3, 0.3_1共2组做比较,分别得文件./output/29_pandrug_top_${top}_${buttom}.txt
    perl 29_pandrug_top_drug_sensitivity_comparison.pl
    Rscript 30_pandrug_comparison_boxplot.R #为./output/29_pandrug_top_${top}_${buttom}.txt画图
#----------------------------------------------------------------------------将drug的predict value 分成top 0_0.5, 0.5_1共2组做比较,分别得文件./output/31_pandrug_top_${top}_${buttom}.txt
    perl 31_pandrug_top_drug_sensitivity_comparison.pl
    Rscript 32_pandrug_comparison_boxplot.R #为./output/31_pandrug_top_${top}_${buttom}.txt画图
#-------------------------------------------------------------------将drug的predict value 分成top 0_0.4, 0.4_1共2组做比较,分别得文件./output/33_pandrug_top_${top}_${buttom}.txt
    perl 33_pandrug_top_drug_sensitivity_comparison.pl
    Rscript 34_pandrug_comparison_boxplot.R #为./output/31_pandrug_top_${top}_${buttom}.txt画图
#-------------------------------------------------------------------将drug的predict value 分成top 0_0.35, 0.35_1共2组做比较,分别得文件./output/35_pandrug_top_${top}_${buttom}.txt
    perl 35_pandrug_top_drug_sensitivity_comparison.pl
    Rscript 36_pandrug_comparison_boxplot.R #为./output/31_pandrug_top_${top}_${buttom}.txt画图