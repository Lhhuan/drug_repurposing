#文件来源于"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V1/huan_data/output/14_merge_oncotree_main_detail_term.txt"文件
cat ./output/CHEMBL25_MEL.txt | cut -f1,2,3,5,6,13,20| sort -ur | head -1 > ./output/uniq_CHEMBL25_MEL_KRAS_HRAS_NRAS.txt
cat ./output/CHEMBL25_MEL.txt | cut -f1,2,3,5,6,13,20| sort -u |grep -w ENSG00000174775>> ./output/uniq_CHEMBL25_MEL_KRAS_HRAS_NRAS.txt
cat ./output/CHEMBL25_MEL.txt | cut -f1,2,3,5,6,13,20| sort -u |grep -w ENSG00000213281 >> ./output/uniq_CHEMBL25_MEL_KRAS_HRAS_NRAS.txt
cat ./output/CHEMBL25_MEL.txt | cut -f1,2,3,5,6,13,20| sort -u |grep -w  ENSG00000133703>> ./output/uniq_CHEMBL25_MEL_KRAS_HRAS_NRAS.txt
perl 01_filter_CHEMBL25_MEL_RAS_path_logic.pl #利用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/10_start_end_path_logical.txt"将./output/uniq_CHEMBL25_MEL_KRAS_HRAS_NRAS.txt的最短路径逻辑文件提取，
#得./output/01_uniq_CHEMBL25_MEL_KRAS_HRAS_NRAS_path_logic.txt

