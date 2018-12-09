wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/International_Consortium_for_Blood_Pressure_GWAS/ICBP-summary-Nature.csv.gz
gzip -cd ICBP-summary-Nature.csv.gz > ICBP-summary-Nature.csv
cp ICBP-summary-Nature.csv 21909115_ICBP_diastolic_blood_pressure,ICBP_systolic_blood_pressure.txt