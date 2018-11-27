#wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsFebruary2017/2016/2016_Barban/AgeFirstBirth_Pooled.txt.gz
gzip -cd  AgeFirstBirth_Pooled.txt.gz > AgeFirstBirth_Pooled.txt
cp AgeFirstBirth_Pooled.txt 27798627_Age_at_first_birth.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsFebruary2017/2016/2016_Barban/NumberChildrenEverBorn_Pooled.txt.gz
gzip -cd NumberChildrenEverBorn_Pooled.txt.gz > NumberChildrenEverBorn_Pooled.txt
cp NumberChildrenEverBorn_Pooled.txt 27798627_Number_of_children.txt