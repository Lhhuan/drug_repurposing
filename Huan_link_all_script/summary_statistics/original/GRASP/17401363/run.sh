wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Yeager/phs000207.pha002877.txt.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Yeager/phs000207.pha002878.txt.gz
#zcat phs000207.pha002877.txt.gz phs000207.pha002878.txt.gz > Prostate_cancer.txt
gzip -cd phs000207.pha002877.txt.gz > phs000207.pha002877.txt 
gzip -cd phs000207.pha002878.txt.gz > phs000207.pha002878.txt 
cp phs000207.pha002877.txt  17401363_Prostate_cancer_1.txt
cp phs000207.pha002878.txt 17401363_Prostate_cancer_2.txt