perl before_add_driver_actionable_statistic_id_project.pl #统计每个mutation id对应的project，统计affected donor >1的id 和Project 得文件before_add_driver_actionable_mutation_ID_project.txt
perl statistic_id_project.pl #统计每个mutation id对应的project，统计affected donor的id 和Project 得文件ID_project.txt
perl add_driver_actionable_id_project.pl #留住ID_project.txt 中的"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt"
#和 cancer specific mutation >1(>=2)的cancer 相关mutation id留住和../12_add_project_mutation_id.txt merge 到一起，add_project_mutation_id的occurance
#用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/pathogenicity_mutation_cancer/output/average_Pathogenic_occurance.txt"
#得最终id_project 文件 ID_project_occur_QC.txt
perl merge_occur_QC_pathogenicity_score.pl #用../cadd_score/SNV_Indel_cadd_score_simple.txt为ID_project_occur_QC.txt添加Pathogenic score ,得merge_occur_QC_pathogenicity_score.txt，没有CADD 的文件./no_cadd_score.txt
perl filter_pathogenicity_mutation_id.pl #用./merge_occur_QC_pathogenicity_score.txt 和
#"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt"
#筛选最终的致病性文件，得pathogenicity mutation id project 文件./Pathogenicity_id_project.txt,得pathogenicity score 文件./pathogenicity_id_cadd_score.txt ,
#得pathogenicity mutation id project cadd score 文件./Pathogenicity_id_project_cadd_score.txt
perl extract_pathogenicity_mutation_postion.pl #用从../simple_somatic_mutation.aggregated.vcf.gz中提取./pathogenicity_id_cadd_score.txt 的位置信息，得./pathogenicity_mutation_postion.txt
#-------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------
perl extract_no_cadd_postion.pl #用../simple_somatic_mutation.largethan0.vcf 提取./no_cadd_score.txt中的位置和ref alt，得。、no_cadd_pos.txt

perl extract_pathogenicity_mutation_hgvsg_2019.6.11.pl  #用../simple_somatic_mutation.largethan0_vep.vcf 中提取./pathogenicity_id_cadd_score.txt 的 hgvsg,得./pathogenicity_mutation_postion_hgvsg.txt,
#并得目前所有mutation的hgvsg文件./icgc_and_add_hgvsg_before_2019.6.11.txt
perl test_cgi_oncogenic_mutation_in_p.pl # 从cgi中下载的catalog_of_validated_oncogenic_mutations.tsv ，看在./pathogenicity_mutation_postion_hgvsg.txt, 或./icgc_and_add_hgvsg_before_2019.6.11.txt 中有多少存在。
#得存在文件./in_pathogenicity_cgi.txt  ./in_icgc_add_cgi.txt 得不存在文件 ./out_pathogenicity_cgi.txt ./out_icgc_add_cgi.txt





# #----------------------
# perl filter_pathogenicity_id.pl # 用../cadd_score/SNV_Indel_cadd_score_simple.txt "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/pathogenicity_mutation_cancer/output/average_Pathogenic_occurance.txt" 筛选致病性的mutation
# #得文件pathogenicity_mutation_id.txt
# perl filter_pathogenicity_id_project.pl #用Final_ID_project.txt和pathogenicity_mutation_id.txt得致病性id和project文件Final_pathogenicity_ID_project.txt



#-------------------------------------------
# perl filter_pathogenicity_id_project.pl #筛选出ID_project.txt中是致病性的mutation及其对应的project. 得文件pathogenicity_id_project.txt,并为project有多个mutation 计数得project_pathogenicity_mutation_number.txt
# #共有pathogenicity mutation 有105125个
# perl count_project_num.pl #统计ID_project.txt中每个project所对应的mutation id的数目，得文件project_id_num.txt，#并且给每个cancer一个id,得文件cancer_id.txt
# # perl merge_project_id_num_oncotree.pl #用cancer_id_full_oncotree.txt为project_id_num.txt文件添加oncotree信息。得文件merge_project_id_num_oncotree.txt
# perl count_oncotree_mutation_count.pl #计算merge_project_id_num_oncotree.txt文件里每个oncotree_id 对应的的num，得文件oncotree-id_mutation_num.txt

# cat oncotree-id_mutation_num.txt | sort -k1,1Vr > sorted_oncotree-id_mutation_num.txt
# perl normal_count_project_num.pl #把sorted_oncotree-id_mutation_num.txt里面number 小于10000的加起来作为一个other,得文件final_oncotree-id_mutation_num.txt
# cat final_oncotree-id_mutation_num.txt | sort -k2,2Vr > sorted_final_oncotree-id_mutation_num.txt
# cp sorted_final_oncotree-id_mutation_num.txt final_oncotree-id_mutation_num_m1.txt
# #手动调整final_oncotree-id_mutation_num_m1.txt 得final_oncotree-id_mutation_num_m.txt

#------------------------------------------------
cp cancer_id.txt  cancer_id_full.txt #并手动给cancer_id_full.txt添加project的全称,并在http://oncotree.mskcc.org/#/home map到oncotree，得cancer_id_full_oncotree1.txt 
perl count_oncotree_cancer_project.pl #统计cancer_id_full_oncotree1.txt 中每个main tissue 中project的数目，得count_main_tissue_cancer_project.txt,统计每个detail tissue中的project的数目，得count_main_detail_cancer_project.txt