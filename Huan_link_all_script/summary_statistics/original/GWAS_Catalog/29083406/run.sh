wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/FerreiraMA_29083406_GCST005038/SHARE-without23andMe.LDSCORE-GC.SE-META.v0.gz
gzip -cd SHARE-without23andMe.LDSCORE-GC.SE-META.v0.gz > SHARE-without23andMe.LDSCORE-GC.SE-META.v0
cp SHARE-without23andMe.LDSCORE-GC.SE-META.v0 29083406_\"Allergic_disease_\(asthma,_hay_fever_or_eczema\)\".txt