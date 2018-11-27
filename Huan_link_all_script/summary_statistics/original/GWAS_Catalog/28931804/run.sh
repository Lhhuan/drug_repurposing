wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/BenyaminB_28931804_GCST004901/Chinese_LMM.txt.gz
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/BenyaminB_28931804_GCST004901/Meta_LMM.txt.gz
zcat Meta_LMM.txt.gz Chinese_LMM.txt.gz > LMM.txt
cp LMM.txt 28931804_Amyotrophic_lateral_sclerosis_\(sporadic\).txt