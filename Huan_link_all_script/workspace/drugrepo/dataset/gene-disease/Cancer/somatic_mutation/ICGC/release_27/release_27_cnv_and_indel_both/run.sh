cp /f/mulinlab/zhouyao/workspace/huan/results/hotspot_svscore/* ./hotspot/
perl 01_filter_pathogenic_sv_cnv.pl #对./hotspot/中的文件进行pathogenic过滤，过滤文件放在./pathogenic_hotspot/  ,并把tra和inv合在一起得./pathogenic_hotspot/all_tra_inv.txt，
#得CNV，dup，del合在一起得./pathogenic_hotspot/all_CNV_dup_del.txt
perl 02_trans_bed_format.pl #把./pathogenic_hotspot/all_CNV_dup_del.txt转换成bed格式，并编号id，最终得文件./pathogenic_hotspot/all_CNV_dup_del.bed
#把./pathogenic_hotspot/all_tra_inv.txt中的两个hotspot 转换成bed格式，最终得文件"./pathogenic_hotspot/all_tra_inv.bed"; 
bedtools intersect -wa -wb -a ./pathogenic_hotspot/all_unique_tra_inv.bed -b /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/sorted_gencode.v19.protein_coding.bed >./pathogenic_hotspot/all_tra_inv_gene.bed
bedtools intersect -wa -wb -a ./pathogenic_hotspot/all_CNV_dup_del.bed -b /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/sorted_gencode.v19.protein_coding.bed >./pathogenic_hotspot/all_CNV_dup_del_gene.bed
perl 03_extract_all_CNV_dup_del.pl #将./pathogenic_hotspot/all_CNV_dup_del_gene.bed中提取sv和cnv的基本信息及其对应的gene，把0 based转换为1 based,得./pathogenic_hotspot/03_all_CNV_dup_del_gene.txt 
perl 03_extract_all_tra_inv.pl #将./pathogenic_hotspot/all_tra_inv_gene.bed的0—based 转换成1-baesd,并且和./pathogenic_hotspot/all_tra_inv.txt merge到一起得./pathogenic_hotspot/03_all_tra_inv_gene.txt
perl 04_merge_all_tra_inv_project_oncotree.pl #将./pathogenic_hotspot/03_all_tra_inv_gene.txt和"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中的project_full_name和oncotree_id等merge到一起
#得./pathogenic_hotspot/04_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt
perl 04_merge_all_CNV_dup_del_project_oncotree.pl #将./pathogenic_hotspot/03_all_CNV_dup_del_gene.txt 和"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中的project_full_name和oncotree_id等merge到一起
#得./pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt



