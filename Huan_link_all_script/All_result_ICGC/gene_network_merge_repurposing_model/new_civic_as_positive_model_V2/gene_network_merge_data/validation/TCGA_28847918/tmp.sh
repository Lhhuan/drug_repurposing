# perl 02_merge_cnv_snv_all_project.pl
# echo -e "finish_02_merge_cnv_snv_all_project\n"
# perl 03_arrange_28847918_to_normal_type.pl
# echo -e "finish_03_arrange_28847918_to_normal_type\n"
# perl 04_test_sample_drug_in_huan_data.pl
# echo -e "finish_04_test_sample_drug_in_huan_data\n"
# perl 05_filter_04_overlap_drug_sample_info.pl
# echo -e "finish_05_filter_04_overlap_drug_sample_info\n"
perl 06_filter_snv_in_icgc.pl 
echo -e "finish_06_filter_snv_in_icgc\n"
perl 07_filter_snv_in_huan.pl
echo -e "finish_07_filter_snv_in_huan\n"
perl 08_filter_cnv_in_huan.pl
echo -e "finish_08_filter_cnv_in_huan\n"
perl 09_calculate_features_for_logistic_regression.pl
echo -e "finish_09_calculate_features_for_logistic_regression\n"

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