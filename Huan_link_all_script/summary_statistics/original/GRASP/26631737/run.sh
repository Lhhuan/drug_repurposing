wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsFebruary2017/2015/2015_Teumer/UACR_overall.csv.gz
zcat UACR_overall.csv.gz > UACR_overall.csv
cp UACR_overall.csv 26631737_Urinary_albumin_to_creatinine_ratio\(UACR\).csv
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsFebruary2017/2015/2015_Teumer/MA.csv.gz
gzip -cd MA.csv.gz > MA.csv
cp MA.csv 26631737_macroalbuminuria\(MA\)in_diabetes.txt