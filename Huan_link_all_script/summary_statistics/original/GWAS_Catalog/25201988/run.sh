wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/RietveldCA_25201988_GCST002598/MA_EA_1st_stage.txt.gz
gzip -cd MA_EA_1st_stage.txt.gz > MA_EA_1st_stage.txt
cp MA_EA_1st_stage.txt 25201988_Educational_attainment.txt