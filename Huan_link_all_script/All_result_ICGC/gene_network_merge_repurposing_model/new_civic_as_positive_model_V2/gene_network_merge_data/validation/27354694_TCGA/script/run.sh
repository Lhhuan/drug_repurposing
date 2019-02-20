perl 04_test_sample_drug_in_huan_data.pl #检测../data/table_s2.txt中的drug 和"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"中drug的overlap,
#得overlap的drug文件./output/04_overlap_drug.txt,及其sample信息得../output/04_overlap_drug_sample_infos.txt，得没有overlap 的drug文件../output/04_no_overlap_drug.txt
perl 05_filter_04_overlap_drug_sample_info.pl  #把../output/04_overlap_drug_sample_infos.txt和../data/output/02_all_project_cnv.txt，../data/output/02_all_project_snv.txt，分别取overlap,
#得../output/05_28847918_cnv.txt和../output/05_28847918_snv.txt  #可以看到，这得到的这两个文件都是hg19的
perl 06_filter_snv_in_icgc.pl #用../output/05_28847918_snv.txt 和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1.vcf"
#取overlap得../output/06_filter_snv_in_icgc.txt
perl 07_filter_snv_in_huan.pl #用../output/06_filter_snv_in_icgc.txt和../../../huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt 取overlap得../output/07_filter_snv_in_huan.txt
perl 08_filter_cnv_in_huan.pl # 用../output/05_28847918_cnv.txt和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt"
#做overlap,得../output/08_filter_cnv_in_huan.txt
perl 09_calculate_features_for_logistic_regression.pl #用../output/07_filter_snv_in_huan.txt 和../output/08_filter_cnv_in_huan.txt 计算用于用于model预测的feature ,得../output/09_calculate_features_for_logistic_regression.txt
Rscript 10_predict_TCGA_data.R # 预测../output/09_calculate_features_for_logistic_regression.txt 得../output/10_prediction_logistic_regression.txt

perl 11_merge_prediction_and_icgc_result.pl #把../output/10_prediction_logistic_regression.txt和../output/04_overlap_drug_sample_infos.txt merge 到一起，得../output/11_prediction_and_icgc_result.txt

#共有27354694_TCGA 中一共有152个药物，有113个在huan中
#共有27354694_TCGA 中一共有1197个sample，有814个在huan下载的数据中，有208个的突变在huan中，可为208个进行预测，用到了59个drug
#
