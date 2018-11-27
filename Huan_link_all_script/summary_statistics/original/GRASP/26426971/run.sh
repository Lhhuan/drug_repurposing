wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Winkler/BMI.MEN.GT50.publicrelease.txt.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Winkler/BMI.MEN.LE50.publicrelease.txt.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Winkler/BMI.WOMEN.GT50.publicrelease.txt.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Winkler/BMI.WOMEN.LE50.publicrelease.txt.gz
zcat BMI.MEN.GT50.publicrelease.txt.gz BMI.MEN.LE50.publicrelease.txt.gz BMI.WOMEN.GT50.publicrelease.txt.gz BMI.WOMEN.LE50.publicrelease.txt.gz > BMI.txt
cp BMI.txt 26426971_BMI.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Winkler/WHRADJ.MEN.GT50.publicrelease.txt.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Winkler/WHRADJ.MEN.LE50.publicrelease.txt.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Winkler/WHRADJ.WOMEN.GT50.publicrelease.txt.gz
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Winkler/WHRADJ.WOMEN.LE50.publicrelease.txt.gz
zcat WHRADJ.MEN.GT50.publicrelease.txt.gz WHRADJ.MEN.LE50.publicrelease.txt.gz WHRADJ.WOMEN.GT50.publicrelease.txt.gz WHRADJ.WOMEN.LE50.publicrelease.txt.gz > WHRADJ.txt
cp WHRADJ.txt 26426971_waist_hip_ratio.txt