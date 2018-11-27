cat "/f/mulinlab/ke/cad_coloc/gwas/cad_meta/formatted_cad_meta_pvalue.txt" | sort -k1,1n -k2,2n > ./paintor/formatted_cad_meta_pvalue_sorted.txt
bash paintor_finemapping0605_revise_huan.sh
mkdir ./paintor/fine_mapping_output_result
cd ./paintor/filtered_loci/
find *.processed > ../input_loci_list
cd ..
PAINTOR -input "/f/mulinlab/huan/summary_statistics/original/ke/new/meta/paintor/input_loci_list" -in "/f/mulinlab/huan/summary_statistics/original/ke/new/meta/paintor/filtered_loci/" -out "/f/mulinlab/huan/summary_statistics/original/ke/new/meta/paintor/fine_mapping_output_result/" -Zhead zscore -LDname ld -enumerate 1 -annotations E097-H3K9me3.narrowPeak.sorted.reformatted
