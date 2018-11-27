wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/MichailidouK_25751625_GCST004950/icogs_bcac_public_results_euro%20\(1\).txt.gz
gzip -cd icogs_bcac_public_results_euro\(1\).txt.gz > icogs_bcac_public_results_euro\(1\).txt
cp icogs_bcac_public_results_euro\(1\).txt 25751625_Breast_cancer.txt

cat "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/25751625/25751625_Breast_cancer_normalized.txt" | sort -k1,1n -k2,2n > ./PAINTOR/25751625_Breast_cancer_normalized_sorted.txt
cp "/f/mulinlab/huan/summary_statistics/original/UKBB_biobank/fine_mapping/paintor/paintor_finemapping0605_revise_huan_ukbb.sh" ./paintor_finemapping0605_revise_huan.sh
bash paintor_finemapping0605_revise_huan.sh
PAINTOR -input "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/25751625/PAINTOR/input_loci_list" -in "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/25751625/PAINTOR/filtered_loci/" -out "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/25751625/PAINTOR/fine_mapping_output_result/" -Zhead Zscore -LDname ld -enumerate 1 -annotations E097-H3K9me3.narrowPeak.sorted.reformatted

