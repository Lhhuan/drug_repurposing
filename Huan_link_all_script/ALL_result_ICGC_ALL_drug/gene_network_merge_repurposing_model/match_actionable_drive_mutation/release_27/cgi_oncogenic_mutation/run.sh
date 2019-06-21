perl test_cgi_oncogenic_mutation_in_icgc.pl # 从cgi中下载的catalog_of_validated_oncogenic_mutations.tsv ，看在 "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/icgc_and_add_hgvsg_before_2019.6.11.txt"
# 中有多少存在。得存在文件./output/in_icgc_add_cgi.txt 得不存在文件./output/out_icgc_add_cgi.txt ，得不存在的文件信息./output/out_icgc_add_cgi_info.txt
perl test_cgi_oncogenic_mutation_in_p.pl ## 从# 从cgi中下载的catalog_of_validated_oncogenic_mutations.tsv ，看在./output/pathogenicity_mutation_postion_hgvsg.txt, 
#得存在文件./output/in_pathogenicity_cgi.txt 得不存在文件 ./output/out_pathogenicity_cgi.txt
grep del ./output/out_icgc_add_cgi.txt > ./output/indel.txt
grep ins ./output/out_icgc_add_cgi.txt >> ./output/indel.txt
cat ./output/indel.txt | sort -u > ./output/unique_indel.txt
#用网页版vep注释./output/unique_indel.txt，得./output/unique_indel_vep.vcf
#网页版vep注释./output/out_icgc_add_cgi.txt ,得./output/out_icgc_add_cgi_vep.vcf
perl 01_merge_out_icgc_info_and_position.pl # 将./output/out_icgc_add_cgi_info.txt和./output/out_icgc_add_cgi_vep.vcf merge到一起，得./output/01_merge_out_icgc_info_and_position.txt
#得对应的unique cancer 文件./output/01_unique_cgi_out_icgc_cancer.txt
perl 02_merge_unique_cgi_out_icgc_cancer_name.pl #将./output/01_unique_cgi_out_icgc_cancer.txt和./output/cancer_acronyms.txt merge 到一起，得./output/02_unique_cgi_out_icgc_cancer_name.txt
#将./output/02_unique_cgi_out_icgc_cancer_name.txt map到 /f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree.txt 得./output/02_unique_cgi_out_icgc_cancer_map_ICGC.txt
perl 03_merge_mutation_disease_project_id.pl #将./output/01_merge_out_icgc_info_and_position.txt和./output/02_unique_cgi_out_icgc_cancer_map_ICGC.txt和/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree.txt
#merge起来，得到mutation_disease_cancer_project三者信息的集合体文件：./output/03_mutation_disease_cancer_project.txt
perl 04_filter_cgi_oncogenic_mutation_in_icgc_out_P.pl #将不在./output/in_pathogenicity_cgi.txt 但./output/in_icgc_add_cgi.txt 中mutation提取出来，得./output/04_out_pathogenicity_In_ICGC.txt