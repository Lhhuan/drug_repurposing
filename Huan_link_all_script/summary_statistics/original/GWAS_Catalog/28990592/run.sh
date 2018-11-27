wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WarringtonNM_28990592_GCST005033/EGG-TotalGWG-Maternal.txt.gz
gzip -cd EGG-TotalGWG-Maternal.txt.gz > EGG-TotalGWG-Maternal.txt
cp EGG-TotalGWG-Maternal.txt 28990592_Gestational_weight_gain_\(maternal_effect\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WarringtonNM_28990592_GCST005034/EGG-LateGWG-Maternal.txt.gz
gzip -cd EGG-LateGWG-Maternal.txt.gz > EGG-LateGWG-Maternal.txt
cp EGG-LateGWG-Maternal.txt 28990592_Late_gestational_weight_gain_\(maternal_effect\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WarringtonNM_28990592_GCST005029/EGG-EarlyGWG-Maternal.txt.gz
gzip -cd EGG-EarlyGWG-Maternal.txt.gz > EGG-EarlyGWG-Maternal.txt
cp EGG-EarlyGWG-Maternal.txt 28990592_Early_gestation_weight_gain_\(maternal_effect\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WarringtonNM_28990592_GCST005030/EGG-LateGWG-Offspring.txt.gz
gzip -cd EGG-LateGWG-Offspring.txt.gz > EGG-LateGWG-Offspring.txt
cp EGG-LateGWG-Offspring.txt  28990592_Late_gestational_weight_gain_\(fetal_effect\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WarringtonNM_28990592_GCST005031/EGG-TotalGWG-Offspring.txt.gz
gzip -cd EGG-TotalGWG-Offspring.txt.gz > EGG-TotalGWG-Offspring.txt
cp EGG-TotalGWG-Offspring.txt 28990592_Gestational_weight_gain_\(fetal_effect\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WarringtonNM_28990592_GCST005032/EGG-EarlyGWG-Offspring.txt.gz
gzip -cd EGG-EarlyGWG-Offspring.txt.gz > EGG-EarlyGWG-Offspring.txt
cp EGG-EarlyGWG-Offspring.txt 28990592_Early_gestational_weight_gain_\(fetal_effect\).txt