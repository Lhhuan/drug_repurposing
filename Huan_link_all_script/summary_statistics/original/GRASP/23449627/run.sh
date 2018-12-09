wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/CousminerPubertalGrowth/Pubertal_growth_10F_12M_combined.txt.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/CousminerPubertalGrowth/Pubertal_growth_PGF_PGM_combined.txt.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/CousminerPubertalGrowth/Pubertal_growth_PGF_PGM_combined.txt.gz
zcat Pubertal_growth_10F_12M_combined.txt.gz Pubertal_growth_PGF_PGM_combined.txt.gz Pubertal_growth_PGF_PGM_combined.txt.gz > Pubertal_growth.txt 
cp Pubertal_growth.txt 23449627_Pubertal_growth.txt