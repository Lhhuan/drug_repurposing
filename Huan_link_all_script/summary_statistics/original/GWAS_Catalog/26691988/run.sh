wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/FritscheLG_26691988_GCST003219/Fritsche-26691988.txt.gz
gzip -cd Fritsche-26691988.txt.gz > Fritsche-26691988.txt
cp Fritsche-26691988.txt.gz 26691988_Advanced_age-related_macular_degeneration.txt