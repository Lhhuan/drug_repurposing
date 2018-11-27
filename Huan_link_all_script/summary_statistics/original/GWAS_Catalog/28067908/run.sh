wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/deLangeKM_28067908_GCST004132/cd_build37_40266_20161107.txt.gz
gzip -cd cd_build37_40266_20161107.txt.gz > cd_build37_40266_20161107.txt
cp cd_build37_40266_20161107.txt 28067908_Crohn\'s_disease.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/deLangeKM_28067908_GCST004131/ibd_build37_59957_20161107.txt.gz
gzip -cd ibd_build37_59957_20161107.txt.gz > ibd_build37_59957_20161107.txt
cp ibd_build37_59957_20161107.txt 28067908_Inflammatory_bowel_disease.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/deLangeKM_28067908_GCST004133/uc_build37_45975_20161107.txt.gz
gzip -cd uc_build37_45975_20161107.txt.gz >  uc_build37_45975_20161107.txt
cp uc_build37_45975_20161107.txt 28067908_Ulcerative_colitis.txt