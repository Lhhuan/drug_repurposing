wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/SpracklenCN_28334899_GCST004232/AGEN_lipids_hapmap_hdl_m2.txt.gz
gzip -cd AGEN_lipids_hapmap_hdl_m2.txt.gz > AGEN_lipids_hapmap_hdl_m2.txt
cp AGEN_lipids_hapmap_hdl_m2.txt 28334899_HDL_cholesterol_levels.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/SpracklenCN_28334899_GCST004237/AGEN_lipids_hapmap_tg_m2.txt.gz
gzip -cd AGEN_lipids_hapmap_tg_m2.txt.gz > AGEN_lipids_hapmap_tg_m2.txt
cp AGEN_lipids_hapmap_tg_m2.txt 28334899_Triglyceride_levels.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/SpracklenCN_28334899_GCST004235/AGEN_lipids_hapmap_tc_m2.txt.gz
gzip -cd AGEN_lipids_hapmap_tc_m2.txt.gz > AGEN_lipids_hapmap_tc_m2.txt
cp AGEN_lipids_hapmap_tc_m2.txt 28334899_Total_cholesterol_levels.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/SpracklenCN_28334899_GCST004233/AGEN_lipids_hapmap_ldl_m2.txt.gz
gzip -cd AGEN_lipids_hapmap_ldl_m2.txt.gz > AGEN_lipids_hapmap_ldl_m2.txt
cp AGEN_lipids_hapmap_ldl_m2.txt 28334899_LDL_cholesterol_levels.txt