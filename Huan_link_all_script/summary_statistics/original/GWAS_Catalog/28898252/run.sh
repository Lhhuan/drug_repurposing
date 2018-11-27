wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WheelerE_28898252_GCST004903/HbA1c_MANTRA.txt.gz
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WheelerE_28898252_GCST004903/HbA1c_METAL_AfricanAmerican.txt.gz
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WheelerE_28898252_GCST004903/HbA1c_METAL_EastAsian.txt.gz
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WheelerE_28898252_GCST004903/HbA1c_METAL_European.txt.gz
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WheelerE_28898252_GCST004903/HbA1c_METAL_SouthAsian.txt.gz
zcat HbA1c*.txt.gz > HbA1c.txt
cp HbA1c.txt 28898252_Glycated_hemoglobin_levels.txt