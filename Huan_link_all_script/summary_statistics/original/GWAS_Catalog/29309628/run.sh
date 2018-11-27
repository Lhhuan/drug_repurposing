wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/BeaumontRN_29309628_GCST005314/MBW_Summary_Stats.txt.gz
gzip -cd MBW_Summary_Stats.txt.gz > MBW_Summary_Stats.txt
cp MBW_Summary_Stats.txt 29309628_Offspring_birth_weight.txt