wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/AkiyamaM_28892062_GCST004904/All_2017_BMI_BBJ_autosome.txt.gz
gzip -cd All_2017_BMI_BBJ_autosome.txt.gz > All_2017_BMI_BBJ_autosome.txt
cp All_2017_BMI_BBJ_autosome.txt 28892062_Body_mass_index.txt