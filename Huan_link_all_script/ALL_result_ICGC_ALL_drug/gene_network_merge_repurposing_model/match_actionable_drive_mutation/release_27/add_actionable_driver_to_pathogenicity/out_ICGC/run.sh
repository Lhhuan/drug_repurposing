perl 01_merge_driver_actionable.pl ##将在ICGC中的actionable 和driver mutation merge 到一起。将../../actionable_mutation/actionable_hit_all_ICGC_mutation/output/04_can_transform_actionable_mutaton_not_in_pathogenicity.txt
#和../../driver_mutation/hit_all_ICGC_mutation/output/05_out_in_ICGC_filter_disease.txt merge到一起，
#得qq ,得unique的mutation disease 文件得./output/01_unique_driver_actionable_disease_out_ICGC.txt   得unique的mutation 文件得./output/01_unique_all_driver_actionable_out_ICGC.txt
#得unique的disease 文件：./output/01_unique_disease.txt
#将 ./output/01_unique_disease.txt map到 /f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree.txt 得./output/01_unique_disease_map_ICGC.txt
perl 02_merge_mutation_disease_project_id.pl #将./output/01_all_driver_action_out_ICGC.txt和./output/01_unique_disease_map_ICGC.txt和/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree.txt
#merge起来，得到mutation_disease_cancer_project三者信息的集合体文件：./output/02_mutation_disease_cancer_project.txt
perl 03_merge_cgi_and_other_mutation_out_icgc.pl #把./output/02_mutation_disease_cancer_project.txt 和
#"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/03_mutation_disease_cancer_project.txt" merge 到一起，
#得./output/03_merge_cgi_and_other_mutation_out_icgc.txt
cat ./output/03_merge_cgi_and_other_mutation_out_icgc.txt | cut -f2 | sort -u  > ./output/03_merge_cgi_and_other_mutation_out_icgc_unique_muatation.txt
#./output/03_merge_cgi_and_other_mutation_out_icgc_unique_muatation.txt 用网页版vep注释，得./output/03_merge_cgi_and_other_mutation_out_icgc_unique_muatation_vep.vcf
cp "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/03_mutation_disease_cancer_project.txt" ./output/