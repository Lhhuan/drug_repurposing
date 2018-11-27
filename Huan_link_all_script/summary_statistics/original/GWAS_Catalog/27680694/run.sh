wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/HorikoshiM_27680694_GCST005146/BW3_EUR_summary_stats.txt.gz
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/HorikoshiM_27680694_GCST005146/BW3_Transethnic_summary_stats.txt.gz
zcat BW3*.txt.gz > BW3_summary_stats.txt
cp BW3_summary_stats.txt 27680694_Birth_weight.txt