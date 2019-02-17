perl 01_check_header.pl #检查所有project (./data/download_TCGA_from_UCSC_xena/${project}/)下CNV和SNV的header是否相同，结果存放在./output/01_cnv_header.txt 和./output/01_snv_header.txt，
#结果显示，project下CNV和SNV的header是相同的
perl 02_merge_cnv_snv_all_project.pl #将所有project (./data/download_TCGA_from_UCSC_xena/${project}/)下CNV和SNV合在一起，得./output/02_all_project_cnv.txt，./output/02_all_project_snv.txt，
perl 03_arrange_28847918_to_normal_type.pl #将./data/28847918/supp9.txt 转换成数组的格式，即：drug sample number 得./output/28847918_normal_type.txt
#-----------------------------------------------------------------------------------------------------------------#筛选28847918中的huan drug
    perl 04_test_sample_drug_in_huan_data.pl #检测./output/28847918_normal_type.txt中的drug 和"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"中drug的overlap,
    #得overlap的drug文件./output/04_overlap_drug.txt,及其sample信息得./output/04_overlap_drug_sample_infos.txt，得没有overlap 的drug文件./output/04_no_overlap_drug.txt
    perl 041_filter_gdsc_drug_wtih_04_no.pl #用./output/04_no_overlap_drug.txt用别名 提取./data/Drug_list_gdsc_11_55_50 2019.tsv 中的信息，;  28847918药物来源于gdsc
    #用./output/04_no_overlap_drug.txt 提取./data/Drug_list_gdsc_11_55_50 2019.tsv 中的信息，;
    #和gdsc有交集 文件./output/041_overlap_drug.txt
    ##和gdsc没有交集"./output/041_no_overlap.txt"
    #和gdsc有交集，和huan有交集 "./output/041_overlap_huan.txt"
    #和gdsc有交集，和huan没有交集 "./output/041_no_overlap_huan.txt"
    #得最终和huan 没有overlap的文件./output/04_final_no_overlap_data.txt
    perl 042_filter_sample.pl #用"./output/041_overlap_huan.txt 取./output/28847918_normal_type.txt中的信息，得./output/042_overlap_drug_sample_infos.txt
    #./output/042_overlap_drug_sample_infos.txt 与./output/04_overlap_drug_sample_infos.txt 合并得最终./output/04_overlap_drug_sample_infos_final.txt ，共64个drug
#--------------------------------------------------------------------
perl 05_filter_04_overlap_drug_sample_info.pl  #把./output/04_overlap_drug_sample_infos_final.txt和./output/02_all_project_cnv.txt，./output/02_all_project_snv.txt，分别取overlap,
#得./output/05_28847918_cnv.txt和./output/05_28847918_snv.txt  #可以看到，这得到的这两个文件都是hg19的
perl 06_filter_snv_in_icgc.pl #用/output/05_28847918_snv.txt 和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1.vcf"
#取overlap得./output/06_filter_snv_in_icgc.txt
perl 07_filter_snv_in_huan.pl #用./output/06_filter_snv_in_icgc.txt和../../huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt 取overlap得./output/07_filter_snv_in_huan.txt
perl 08_filter_cnv_in_huan.pl # 用./output/05_28847918_cnv.txt和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt"
#做overlap,得./output/08_filter_cnv_in_huan.txt
perl 09_calculate_features_for_logistic_regression.pl #用./output/07_filter_snv_in_huan.txt 和./output/08_filter_cnv_in_huan.txt 计算用于用于model预测的feature ,得./output/09_calculate_features_for_logistic_regression.txt

Rscript 10_predict_TCGA_data.R # 预测./output/09_calculate_features_for_logistic_regression.txt 得./output/10_prediction_logistic_regression.txt
    perl 11_01_merge_snv_in_huan_with_mutation_info.pl #根据./output/07_filter_snv_in_huan.txt中的mutation_id,
    #利用"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1.vcf"将mutation的具体信息和./output/07_filter_snv_in_huan.txt连起来
    #得./output/11_01_snv_in_huan_info.txt
    perl 11_merge_prediction_and_icgc_result_info.pl #把./output/10_prediction_logistic_regression.txt和./output/28847918_normal_type.txt merge 到一起，级drug cancer sample pair对应的突变信息merge到一起（./output/11_01_snv_in_huan_info.txt），
    #得./output/11_prediction_and_icgc_result_info.txt
perl 11_merge_prediction_and_icgc_result.pl ##把./output/10_prediction_logistic_regression.txt和./output/28847918_normal_type.txt merge 到一起，得./output/11_prediction_and_icgc_result.txt

#-----------------------------------------------------------------------------------------------一些其他的验证
    Rscript 11_sort_value_in_paper.R  #对./output/11_prediction_and_icgc_result.txt 按照value in paper升序排列，得./output/11_prediction_and_icgc_result_sorted_by_value_in_paper.txt
    head -7174 ./output/11_prediction_and_icgc_result_sorted_by_value_in_paper.txt > ./output/11_prediction_and_icgc_result_sorted_by_value_in_paper_top_0.1.txt
    perl 12_value_in_paper_top0.1_overlap_prediction_top0.1.pl #看./output/11_prediction_and_icgc_result_top0.1.txt和./output/11_prediction_and_icgc_result_sorted_by_value_in_paper_top_0.1.txt的overlap
    #得./output/12_value_in_paper_top0.1_overlap_prediction_top0.1.txt


    perl 14_paper_drug_cancer_overlap_with_Positive_sample.pl #看../../test_data/output/09_filter_test_data_for_logistic_regression.txt 中的drug cancer pair是否和./output/11_prediction_and_icgc_result.txt
    #中的drug cancer pair有重叠，得有重叠的文件./output/14_paper_drug_cancer_overlap_with_Positive_sample.txt,得没有重叠的文件./output/14_paper_drug_cancer_out_Positive_sample.txt
    Rscript 14_boxplot.R #把./output/14_paper_drug_cancer_overlap_with_Positive_sample.txt 和 ./output/14_paper_drug_cancer_out_Positive_sample.txt画box plot
    cat ./output/14_paper_drug_cancer_out_Positive_sample.txt | sort -t $'\t'  -k1,1V -k3,3V -k6,6g > ./output/sorted_14_paper_drug_cancer_out_Positive_sample.txt
#-----------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------对cat ./output/11_prediction_and_icgc_result.txt按照不同的需求排序
    cat ./output/11_prediction_and_icgc_result.txt | sort -t $'\t' -k1,1V -k3,3V -k6,6rg > ./output/11_prediction_and_icgc_result_sorted_by_drug_cancer_prediction_value.txt #把./output/11_prediction_and_icgc_result.txt 
    #按照 drug cancer prediction score 排序得./output/11_prediction_and_icgc_result_sorted_by_drug_cancer_prediction_value.txt
    cat ./output/11_prediction_and_icgc_result.txt | sort -t $'\t' -k1,1V -k6,6rg > ./output/11_prediction_and_icgc_result_sorted_by_drug_prediction_value.txt #把./output/11_prediction_and_icgc_result.txt 
    #按照 drug prediction score 排序得./output/11_prediction_and_icgc_result_sorted_by_drug_prediction_value.txt
    wc -l ./output/11_prediction_and_icgc_result_sorted_by_drug_prediction_value.txt #71744 共71743 个drug cancer sample pairs
#---------------------------------------------------------------------------------------------------- #用pancancer pandrug 进行验证top 和bottom 的drug sensitity进行比较,看是否有显著性差异
    perl 15_pandrug_top_buttom_drug_sensitivity_comparison.pl #用./output/11_prediction_and_icgc_result.txt pandrug 的比较top 和bottom 的drug sensitity,
    #得./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.1.txt, ./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.2.txt ./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.3.txt
    #./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.4.txt ./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.5.txt
    Rscript 16_pandrug_top_buttom_drug_sensitivity_comparison_boxplot.R #为./output/15_pandrug_top_buttom_drug_sensitivity_comparison_*.txt 画box_plot
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