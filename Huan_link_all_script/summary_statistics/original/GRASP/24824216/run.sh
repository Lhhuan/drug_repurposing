wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Myers/HMG-2013-W-01483_Myers_DataS1_MaleCases_vsPooledControls.csv.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Myers/HMG-2013-W-01483_Myers_DataS2_FemaleCases_vsPooledControls.csv.gz
zcat HMG-2013-W-01483_Myers_DataS1_MaleCases_vsPooledControls.csv.gz  HMG-2013-W-01483_Myers_DataS2_FemaleCases_vsPooledControls.csv.gz > Asthma.txt
cp Asthma.txt 24824216_Asthma.txt