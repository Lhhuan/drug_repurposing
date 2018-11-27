wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Global_Lipids_Genetics_Consortium/jointGwasMc_HDL.txt.gz
gzip -cd jointGwasMc_HDL.txt.gz > jointGwasMc_HDL.txt
cp jointGwasMc_HDL.txt 24097068_HDL.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Global_Lipids_Genetics_Consortium/jointGwasMc_LDL.txt.gz
gzip -cd  jointGwasMc_LDL.txt.gz > jointGwasMc_LDL.txt
cp jointGwasMc_LDL.txt 24097068_LDL.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Global_Lipids_Genetics_Consortium/jointGwasMc_TG.txt.gz
gzip -cd jointGwasMc_TG.txt.gz > jointGwasMc_TG.txt
cp jointGwasMc_TG.txt 24097068_TG.txt
wget -c  https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Global_Lipids_Genetics_Consortium/jointGwasMc_TC.txt.gz
gzip -cd  jointGwasMc_TC.txt.gz > jointGwasMc_TC.txt
cp jointGwasMc_TC.txt 24097068_total_cholesterol.txt