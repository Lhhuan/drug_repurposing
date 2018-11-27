cat ../28346442_Epithelial_ovarian_cancer_normalized.txt | sort -k1,1n -k2,2n > ./paintor/28346442_Epithelial_ovarian_cancer_normalized_sorted.txt
bash paintor_finemapping0605_revise_huan.sh
mkdir ./paintor/fine_mapping_output_result
cd ./paintor/filtered_loci/
find *.processed > ../input_loci_list
cd ..
PAINTOR -input "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/28346442/Epithelial_ovarian_cancer/fine_mapping/paintor/input_loci_list" -in "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/28346442/Epithelial_ovarian_cancer/fine_mapping/paintor/filtered_loci/" -out "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/28346442/Epithelial_ovarian_cancer/fine_mapping/paintor/fine_mapping_output_result/" -Zhead Zscore -LDname ld -enumerate 1 -annotations E097-H3K9me3.narrowPeak.sorted.reformatted
