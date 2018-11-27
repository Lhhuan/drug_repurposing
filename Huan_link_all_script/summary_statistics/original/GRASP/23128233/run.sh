wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Jostins/gwas_ichip_meta_release.txt.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Jostins/cd-meta.txt.gz
gzip -cd cd-meta.txt.gz > cd-meta.txt
cp cd-meta.txt 23128233_Inflammatory_bowel_disease:Crohn\'s_disease.txt
gzip -cd gwas_ichip_meta_release.txt.gz > gwas_ichip_meta_release.txt
cp gwas_ichip_meta_release.txt 23128233_Inflammatory_bowel_disease:ulcerative_colitis.txt