wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/EstradaK_22504420_GCST001482/GEFOS2_FNBMD_POOLED_GC.txt.gz
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/EstradaK_22504420_GCST001482/GEFOS2_LSBMD_POOLED_GC.txt.gz
zcat GEFOS2_FNBMD_POOLED_GC.txt.gz GEFOS2_LSBMD_POOLED_GC.txt.gz > GEFOS2_FNBMD_POOLED_GC.txt
cp GEFOS2_FNBMD_POOLED_GC.txt 22504420_Bone_mineral_density.txt