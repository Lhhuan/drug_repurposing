wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/LeeJC_28067912_GCST004053/CD_prognosis_GWA_results.csv.zip
gzip -cd CD_prognosis_GWA_results.csv.zip > CD_prognosis_GWA_results.csv
cp CD_prognosis_GWA_results.csv 28067912_Poor_prognosis_in_Crohn\'s_disease.txt