tar xf Summary_Statistics_GWAS_2016.tar
zcat ./Summary_Statistics_GWAS_2016/als.sumstats.lmm.chr* | sort -u > als.sumstats.lmm.txt
cp als.sumstats.lmm.txt 27455348_Amyotrophic_lateral_sclerosis.txt