wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/SniekersS_28530673_GCST004364/sumstats.txt.gz
gzip -cd sumstats.txt.gz > sumstats.txt
cp sumstats.txt 28530673_Intelligence.txt