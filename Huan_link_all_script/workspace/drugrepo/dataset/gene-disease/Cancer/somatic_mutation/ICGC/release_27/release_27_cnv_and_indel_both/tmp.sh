perl 01_filter_pathogenic_sv_cnv.pl
echo -e "finish_01_filter_pathogenic_sv_cnv\n"
perl 02_trans_bed_format.pl
echo -e "finish_02_trans_bed_format\n"
bedtools intersect -wa -wb -a ./pathogenic_hotspot/all_unique_tra_inv.bed -b /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/sorted_gencode.v19.protein_coding.bed >./pathogenic_hotspot/all_tra_inv_gene.bed
bedtools intersect -wa -wb -a ./pathogenic_hotspot/all_CNV_dup_del.bed -b /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/sorted_gencode.v19.protein_coding.bed >./pathogenic_hotspot/all_CNV_dup_del_gene.bed
perl 03_extract_all_CNV_dup_del.pl
echo -e "finish_03_extract_all_CNV_dup_del\n"
perl 03_extract_all_tra_inv.pl
echo -e "finish_03_extract_all_tra_inv\n"
perl 04_merge_all_tra_inv_project_oncotree.pl
echo -e "finish_04_merge_all_tra_inv_project_oncotree\n"
perl 041_sort_all_tra_inv_project_oncotree.pl
echo -e "finish_041_sort_all_tra_inv_project_oncotree\n"
perl 04_merge_all_CNV_dup_del_project_oncotree.pl
echo -e "finish_04_merge_all_CNV_dup_del_project_oncotree\n"
perl 05_merge_all_cnv_sv_project.pl
echo -e "finish_05_merge_all_cnv_sv_project\n"
perl 05_merge_cnv_sv_all.pl
echo -e "finish_05_merge_cnv_sv_all\n"
perl split_pathogenic_tra_project_count_hotspot_number.pl 
echo -e "finish_split_pathogenic_tra_project_count_hotspot_number\n"
perl split_pathogenic_inv_project_count_hotspot_number.pl
echo -e "finish_split_pathogenic_inv_project_count_hotspot_number\n"
perl split_pathogenic_del_project_count_hotspot_number.pl
echo -e "finish_split_pathogenic_del_project_count_hotspot_number\n"
perl split_pathogenic_cnv_project_count_hotspot_number.pl
echo -e "finish_split_pathogenic_cnv_project_count_hotspot_number\n"
perl split_pathogenic_dup_project_count_hotspot_number.pl
echo -e "finish_all\n"