wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/SoranzoN_20858683_GCST000803/MAGIC_HbA1C.txt.gz
gzip -cd MAGIC_HbA1C.txt.gz > MAGIC_HbA1C.txt 
cp MAGIC_HbA1C.txt 20858683_Glycated_hemoglobin_levels.txt