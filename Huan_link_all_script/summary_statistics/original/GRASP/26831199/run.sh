#wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsFebruary2017/2016/2016_Pattaro_kidney/CKD.csv.gz
gzip -cd CKD.csv.gz > CKD.csv
cp CKD.csv 26831199_chronic_kidney_disease.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsFebruary2017/2016/2016_Pattaro_kidney/eGFRcrea_overall.csv.gz
gzip -cd eGFRcrea_overall.csv.gz > eGFRcrea_overall.csv
cp eGFRcrea_overall.csv 26831199_estimated_glomerular_filtration_rate_from_serum_creatinine.csv
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsFebruary2017/2016/2016_Pattaro_kidney/eGFRcys_overall.csv.gz
gzip -cd eGFRcys_overall.csv.gz >  eGFRcys_overall.csv
cp eGFRcys_overall.csv 26831199_estimated_glomerular_filtration_rate_from_cystatin_C.csv