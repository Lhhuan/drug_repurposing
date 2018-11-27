wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/SpringelkampH_28073927_GCST004137/Meta_CA_age_sex_DA_caucasians_asians_MAF0.01_20160807_newGC.1tbl.gz
gzip -cd Meta_CA_age_sex_DA_caucasians_asians_MAF0.01_20160807_newGC.1tbl.gz > Meta_CA_age_sex_DA_caucasians_asians_MAF0.01_20160807_newGC.1tbl
cp Meta_CA_age_sex_DA_caucasians_asians_MAF0.01_20160807_newGC.1tbl 28073927_Optic_cup_area.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/SpringelkampH_28073927_GCST004074/Meta_IOP_age_sex_caucasians_asians_MAF0.01_20160806_newGC.1tbl.gz
gzip -cd Meta_IOP_age_sex_caucasians_asians_MAF0.01_20160806_newGC.1tbl.gz > Meta_IOP_age_sex_caucasians_asians_MAF0.01_20160806_newGC.1tbl
cp Meta_IOP_age_sex_caucasians_asians_MAF0.01_20160806_newGC.1tbl 28073927_Intraocular_pressure.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/SpringelkampH_28073927_GCST004076/Meta_DA_age_sex_caucasians_asians_MAF0.01_20160806_newGC.1tbl.gz
gzip -cd  Meta_DA_age_sex_caucasians_asians_MAF0.01_20160806_newGC.1tbl.gz > Meta_DA_age_sex_caucasians_asians_MAF0.01_20160806_newGC.1tbl
cp Meta_DA_age_sex_caucasians_asians_MAF0.01_20160806_newGC.1tbl.gz 28073927_Optic_disc_area.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/SpringelkampH_28073927_GCST004075/Meta_VCDR_age_sex_caucasians_asians_withoutSouthampton_MAF0.01_20160806_newGC.1tbl.gz
gzip -cd Meta_VCDR_age_sex_caucasians_asians_withoutSouthampton_MAF0.01_20160806_newGC.1tbl.gz > Meta_VCDR_age_sex_caucasians_asians_withoutSouthampton_MAF0.01_20160806_newGC.1tbl
cp Meta_VCDR_age_sex_caucasians_asians_withoutSouthampton_MAF0.01_20160806_newGC.1tbl 28073927_Vertical_cup-disc_ratio.txt
