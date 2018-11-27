#wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/vanderHarstP_29212778_GCST005195/CAD_META.gz
gzip -cd  CAD_META.gz > CAD_META.txt
cp CAD_META.txt 29212778_Coronary_artery_disease.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/vanderHarstP_29212778_GCST005194/CAD_UKBIOBANK.gz
gzip -cd CAD_UKBIOBANK.gz > CAD_UKBIOBANK.txt
cp CAD_UKBIOBANK.txt 29212778_Coronary_artery_disease1.txt