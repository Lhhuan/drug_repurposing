cat ../data/CCLE_sample_info_file_2012-10-18.txt | cut -f5,6,7 | sort -u > ../output/unique_cancer.txt # unique 的cancer
#将 ../output/unique_cancer.txt map 到http://oncotree.mskcc.org/#/home 得../output/unique_cancer_oncotree.txt
perl 01_merge_sample_info_oncotree.pl # ../output/unique_cancer_oncotree.txt 和../data/CCLE_sample_info_file_2012-10-18.txt 得../output/01_merge_sample_info_oncotree.txt
perl 02_merge_sample_oncotree_drug.pl #将../output/01_merge_sample_info_oncotree.txt 和../data/CCLE_NP24.2009_Drug_data_2015.02.24.txt merge 到一起，得../output/02_merge_sample_oncotree_drug.txt
perl 021_merge_sample_oncotree_chembl.pl #将../output/02_merge_sample_oncotree_drug.txt 和"/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" 通过Drug_claim_primary_name merge,得
#../output/021_merge_sample_oncotree_chembl.txt
perl 03_extract_snv_cnv_sv.pl #用../data/CCLE_DepMap_18q3_maf_20180718.txt 和../data/CCLE_copynumber_2013-12-03.seg.txt， ../data/CCLE_translocations_SvABA_20181221.txt 提取../output/021_merge_sample_oncotree_chembl.txt中
#的varint 信息，得../output/snv_sample.txt  ../output/cnv_sample.txt ../output/tra_sample.txt 
perl 04_filter_snv_in_ICGC.pl #用../output/snv_sample.txt 和
#../../../Actionable_mutation_TCGA_28847918/output/07_ICGC_mutation_id_HGVSg.txt 根据hgvsg
#取overlap得../output/04_filter_snv_in_icgc.txt
perl 05_filter_snv_in_huan.pl ##用../output/04_filter_snv_in_icgc.txt和../../../../huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt 取overlap得../output/05_filter_snv_in_huan.txt
perl 06_filter_CNV_in_huan.pl ## 用../output/cnv_sample.txt和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt"
#做overlap,得../output/06_filter_cnv_in_huan.txt
perl 0701_sort_tra_sample.pl #对../output/tra_sample.txt 中的chr1,start1,end1, chr2,start2,end2进行排序，让小的在前面，得../output/sorted_tra_sample.txt
perl 07_filter_TRA_in_huan.pl #用../output/sorted_tra_sample.txt 和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_sorted_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt"
#做overlap,得../output/07_tra_in_huan.txt
perl 08_merge_all_sv.pl #把 ../output/07_tra_in_huan.txt 和 ../output/06_filter_cnv_in_huan.txt merge到一起，得../output/08_merge_all_sv.txt
perl 09_calculate_features_for_logistic_regression.pl #用../output/08_merge_all_sv.txt 和../output/05_filter_snv_in_huan.txt 计算features.得../output/09_calculate_features_for_logistic_regression.txt
Rscript 10_prediction_repurposing.R #为../output/09_calculate_features_for_logistic_regression.txt进行预测，得../output/10_prediction_logistic_regression.txt
perl 11_merge_prediction_repurposing_drug_sensitive_info.pl #将../output/10_prediction_logistic_regression.txt 和../output/021_merge_sample_oncotree_chembl.txt merge 到一起，得../output/11_merge_prediction_repurposing_drug_sensitive_info.txt
cat ../output/11_merge_prediction_repurposing_drug_sensitive_info.txt |cut -f1,2,3,4,19,20,21,22 >../output/11_merge_prediction_repurposing_drug_sensitive_info_sample.txt
perl 12_top_prediction_sensitivity_comparsion.pl # #将../output/11_merge_prediction_repurposing_drug_sensitive_info_sample.txt prediction value 分成top 0-0.1, 0.1-0.9, 0.9-1 共3组做比较,
#分别得文件../output/12_pandrug_top_${top}_${buttom}.txt
Rscript 13_pandrug_comparison_boxplot.R