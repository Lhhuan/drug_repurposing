#wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsFebruary2017/2016/2016_Schumann/pooled_continuous_alcohol.csv.gz
gzip -cd pooled_continuous_alcohol.csv.gz > pooled_continuous_alcohol.csv
cp pooled_continuous_alcohol.csv 27911795_Daily_alcohol_use_continuous.csv
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsFebruary2017/2016/2016_Schumann/pooled_dichotomous_alcohol.csv.gz
gzip -cd pooled_dichotomous_alcohol.csv.gz > pooled_dichotomous_alcohol.csv
cp pooled_dichotomous_alcohol.csv > 27911795_Daily_alcohol_use_dichotomous.csv