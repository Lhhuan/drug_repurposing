#wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2015/2015_Nikpey_CardioGramC4D/cad.additive.Oct2015.pub.zip
wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2015/2015_Nikpey_CardioGramC4D/cad.recessive.Oct2015.pub.zip
zcat cad.additive.Oct2015.pub.zip cad.recessive.Oct2015.pub.zip > cad.txt
cp cad.txt 26343387_Coronary_artery_disease.txt