#wget ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WalfordGA_27416945_GCST003658/MAGIC_ISI_Model_2_AgeSexBMI.txt
cp MAGIC_ISI_Model_2_AgeSexBMI.txt 27416945_Modified_Stumvoll_Insulin_Sensitivity_Index_\(model_adjusted_for_BMI\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WalfordGA_27416945_GCST005178/MAGIC_ISI_Model_1_AgeSexOnly.txt
cp MAGIC_ISI_Model_1_AgeSexOnly.txt  27416945_Modified_Stumvoll_Insulin_Sensitivity_Index.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/WalfordGA_27416945_GCST003659/MAGIC_ISI_Model_3_JMA.txt
cp MAGIC_ISI_Model_3_JMA.txt  27416945_Modified_Stumvoll_Insulin_Sensitivity_Index_\(BMI_interaction\).txt