wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/MichailidouK_29059683_GCST004988/oncoarray_bcac_public_release_oct17%20\(1\).txt.gz
gzip -cd oncoarray_bcac_public_release_oct17\(1\).txt.gz > oncoarray_bcac_public_release_oct17\(1\).txt
cp oncoarray_bcac_public_release_oct17\(1\).txt 29059683_Breast_cancer.txt
