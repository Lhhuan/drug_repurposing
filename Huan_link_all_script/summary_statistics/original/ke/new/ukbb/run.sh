cat "/f/mulinlab/ke/cad_coloc/gwas/cad_meta/formatted_cad_ukbb_pval.txt" | sort -k1,1n -k2,2n > ./paintor/formatted_cad_ukbb_pval_sorted.txt
bash paintor_finemapping0605_revise_huan.sh
mkdir ./paintor/fine_mapping_output_result
cd ./paintor/filtered_loci/
find *.processed > ../input_loci_list
cd ..
PAINTOR -input "/f/mulinlab/huan/summary_statistics/original/ke/new/ukbb/paintor/input_loci_list" -in "/f/mulinlab/huan/summary_statistics/original/ke/new/ukbb/paintor/filtered_loci/" -out "/f/mulinlab/huan/summary_statistics/original/ke/new/ukbb/paintor/fine_mapping_output_result/" -Zhead Zval -LDname ld -enumerate 1 -annotations E097-H3K9me3.narrowPeak.sorted.reformatted
