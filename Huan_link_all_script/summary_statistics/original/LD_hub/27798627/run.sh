wget http://sociogenome.com/material/GWASresults/AgeFirstBirth_Pooled.txt.gz
gzip -cd AgeFirstBirth_Pooled.txt.gz > AgeFirstBirth_Pooled.txt
cp AgeFirstBirth_Pooled.txt 27798627_Age_of_first_birth.txt
wget http://sociogenome.com/material/GWASresults/NumberChildrenEverBorn_Pooled.txt.gz
gzip -cd NumberChildrenEverBorn_Pooled.txt.gz > NumberChildrenEverBorn_Pooled.txt
cp NumberChildrenEverBorn_Pooled.txt  27798627_Number_of_children_ever_born.txt