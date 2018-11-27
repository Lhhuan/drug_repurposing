wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/CONVERGE_Consortium/MD_GWAS_SNPresults.txt.gz
gzip -cd MD_GWAS_SNPresults.txt.gz > MD_GWAS_SNPresults.txt
cp MD_GWAS_SNPresults.txt 26176920_Major_depressive_disorder.txt