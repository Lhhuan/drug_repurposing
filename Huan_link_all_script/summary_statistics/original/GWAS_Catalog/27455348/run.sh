wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/vanRheenenW_27455348_GCST004692/Summary_Statistics_GWAS_2016.tar
tar zxvf Summary_Statistics_GWAS_2016.tar
zcat ./Summary_Statistics_GWAS_2016/als.sumstats.lmm.chr*.txt.gz > als.sumstats.lmm.txt
cp als.sumstats.lmm.txt 27455348_Amyotrophic_lateral_sclerosis.txt