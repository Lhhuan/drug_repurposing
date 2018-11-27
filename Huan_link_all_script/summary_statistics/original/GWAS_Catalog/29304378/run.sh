wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/Medina-GomezC_29304378_GCST005349/METAANALYSIS2016_60_or_more_GEFOS.txt.gz
gzip -cd METAANALYSIS2016_60_or_more_GEFOS.txt.gz > METAANALYSIS2016_60_or_more_GEFOS.txt
cp METAANALYSIS2016_60_or_more_GEFOS.txt 29304378_Total_body_bone_mineral_density_\(age_over_60\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/Medina-GomezC_29304378_GCST005350/METAANALYSIS2016_4560GEFOS.txt.gz
gzip -cd METAANALYSIS2016_4560GEFOS.txt.gz > METAANALYSIS2016_4560GEFOS.txt
cp METAANALYSIS2016_4560GEFOS.txt 29304378_Total_body_bone_mineral_density_\(age_45-60\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/Medina-GomezC_29304378_GCST005346/METAANALYSIS2016_3045GEFOS.txt.gz
gzip -cd METAANALYSIS2016_3045GEFOS.txt.gz > METAANALYSIS2016_3045GEFOS.txt
cp METAANALYSIS2016_3045GEFOS.txt 29304378_Total_body_bone_mineral_density_\(age_30-45\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/Medina-GomezC_29304378_GCST005344/METAANALYSIS2016_1530GEFOS.txt.gz 
gzip -c METAANALYSIS2016_1530GEFOS.txt.gz > METAANALYSIS2016_1530GEFOS.txt
cp METAANALYSIS2016_1530GEFOS.txt 29304378_Total_body_bone_mineral_density_\(age_15-30\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/Medina-GomezC_29304378_GCST005345/METAANALYSIS2016_15_or_lessGEFOS.txt.gz
gzip -c METAANALYSIS2016_15_or_lessGEFOS.txt.gz > METAANALYSIS2016_15_or_lessGEFOS.txt
cp METAANALYSIS2016_15_or_lessGEFOS.txt 29304378_Total_body_bone_mineral_density_\(age_0-15\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/Medina-GomezC_29304378_GCST005348/METAANALYSIS2016_all_GEFOS.txt.gz
gzip -cd METAANALYSIS2016_all_GEFOS.txt.gz > METAANALYSIS2016_all_GEFOS.txt
cp METAANALYSIS2016_all_GEFOS.txt 29304378_Total_body_bone_mineral_density.txt