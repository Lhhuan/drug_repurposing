cp "/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/Actionable_mutation_TCGA_28847918/output/12_merge_civic_and_mtctscan_other_database.txt" ./output/all_actionable_mutation.txt
perl 01_extract_ICGC_mutation_id_HGVSg.pl #将"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1_vep.vcf"
#中的mutation id和HVSGg提取出来，得./output/01_ICGC_mutation_id_HGVSg.txt
perl 02_merge_pathogenicity_mutation_hgvsg.pl # 把"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/pathogenicity_mutation_cancer/output/pathogenicity_mutation_ID.txt"
#和 ./output/01_ICGC_mutation_id_HGVSg.txt merge 到一起，得./output/02_pathogenicity_mutation_hgvsg.txt
perl 03_transvar_ref_alt.pl #把区分./output/all_actionable_mutation.txt里面的突变类型是否可以用transvar 转换,得./output/03_actionable_mutation_transvar_ref_alt.txt
#此步中报错没有关系，表明不能为该位点不能用transvar转
perl 04_find_actionable_mutaton_in_pathogenicity.pl #寻找actionable mutation中的pathogenicity_mutation，寻找在./output/02_pathogenicity_mutation_hgvsg.txt中出现的./output/03_actionable_mutation_transvar_ref_alt.txt
#得./output/04_actionable_mutaton_in_pathogenicity.txt 得所有的actionable mutation文件./output/04_all_actionable_mutation.txt，得可以转成hgvs的actionable_mutation文件./output/04_actionable_mutation_can_transform_hgvs.txt 
#得不可以转成hgvs的actionable_mutation文件./output/04_actionable_mutation_can_not_transform_hgvs.txt 
