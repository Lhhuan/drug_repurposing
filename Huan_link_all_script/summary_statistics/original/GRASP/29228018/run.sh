wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2017/2017_Roos_Rotator_Cuff/RotatorCuffSummary.txt.zip
gzip -cd  RotatorCuffSummary.txt.zip > RotatorCuffSummary.txt
cp RotatorCuffSummary.txt 29228018_Rotator_cuff_injury.txt
