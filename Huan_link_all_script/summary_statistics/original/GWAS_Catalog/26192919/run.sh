wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/LiuJZ_26192919_GCST003045/UC_trans_ethnic_association_summ_stats_b37.txt.gz
gzip -cd UC_trans_ethnic_association_summ_stats_b37.txt.gz > UC_trans_ethnic_association_summ_stats_b37.txt
cp UC_trans_ethnic_association_summ_stats_b37.txt 26192919_Ulcerative_colitis.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/LiuJZ_26192919_GCST003043/IBD_trans_ethnic_association_summ_stats_b37.txt.gz
gzip -cd  IBD_trans_ethnic_association_summ_stats_b37.txt.gz > IBD_trans_ethnic_association_summ_stats_b37.txt
cp IBD_trans_ethnic_association_summ_stats_b37.txt 26192919_Inflammatory_bowel_disease.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/LiuJZ_26192919_GCST003044/CD_trans_ethnic_association_summ_stats_b37.txt.gz
gzip -cd  CD_trans_ethnic_association_summ_stats_b37.txt.gz > CD_trans_ethnic_association_summ_stats_b37.txt
cp CD_trans_ethnic_association_summ_stats_b37.txt 26192919_Crohn\'s_disease.txt