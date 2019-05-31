# perl filter_pathogenicity_mutation_cancer.pl #用../output/12_merge_ICGC_info_gene_role.txt
# #和"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/cadd_score/SNV_Indel_cadd_score_simple.txt" 文件，得CADD score >15 的variant 及其对应的基因信息。
# #得./output/pathogenicity_mutation_cancer.txt，得所有的cadd>=15的mutation id文件./output/pathogenicity_mutation_ID.txt

# #--------------------------------------------------#计算Pathogenic mutation 平均突变频率
# # cp ./output/Pathogenic_snv_indel_project.txt ./output/before_add_actionable_driver_Pathogenic_snv_indel_project.txt
# perl count_average_Pathogenic_occurance.pl #用./output/before_add_actionable_driver_Pathogenic_snv_indel_project.txt 计算Pathogenic mutation 平均突变频率，得文件./output/average_Pathogenic_occurance.txt
# #----------------------------------------------------------- #为画图准备数据
# less ./output/pathogenicity_mutation_cancer.txt | cut -f2 | sort -u | wc -l #83675个CADD >=15，cancer specific affectd donor>1 的 Pathogenic mutation 
# less ./output/pathogenicity_mutation_cancer.txt | cut -f3 | sort -u | wc -l #  mutation map 到16283个 gene 



# cat ./output/pathogenicity_mutation_cancer.txt|head -1 | cut -f1,2,6,7 >./output/Pathogenic_snv_indel_project.txt
# cat ./output/pathogenicity_mutation_cancer.txt|awk 'NR>1' | cut -f1,2,6,7 | sort -u >>./output/Pathogenic_snv_indel_project.txt
perl merge_p_score_mutation_cancer.pl  #用../output/12_merge_ICGC_info_gene_role.txt
#和"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_id_cadd_score.txt" 文件merge
#得./output/pathogenicity_mutation_cancer.txt，得所有致病性mutation id文件./output/pathogenicity_mutation_ID.txt

perl count_number_of_Pathogenic_mutation_map_to_per_level.pl #统计./output/pathogenicity_mutation_cancer.txt中 map to gene level 的每个level的mutation的数目，得./output/count_number_of_Pathogenic_mutation_map_to_per_level.txt
#统计gene moa, 统计每种moa 下的gene数及其比例，得./output/count_number_of_cancer_gene_MOA.txt


cat ../output/12_merge_ICGC_info_gene_role.txt| cut -f2 | sort -u | wc -l #16292

cat ./output/pathogenicity_mutation_cancer.txt|head -1 | cut -f1,2,6,7 >./output/Pathogenic_snv_indel_project.txt
cat ./output/pathogenicity_mutation_cancer.txt|awk 'NR>1' | cut -f1,2,6,7 | sort -u >>./output/Pathogenic_snv_indel_project.txt

perl merge_p_snv_sv.pl ##将./output/Pathogenic_snv_indel_project.txt 和"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_SV_CNV/v4/output/all_sv_snv.vcf"
#merge到一起，得各种类型数据统计数据./output/sv_snv_number.txt #得各project中，sv和cnv数目统计数据得./output/project_mutation_type_number.txt,得总表./output/merge_P_snv_sv.txt



