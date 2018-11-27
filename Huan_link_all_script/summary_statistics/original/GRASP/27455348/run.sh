wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2016/2016_van_Rheenen/ALSdiscoveryLMM.txt.gz
gzip -cd ALSdiscoveryLMM.txt.gz > ALSdiscoveryLMM.txt
cp ALSdiscoveryLMM.txt 27455348_Amyotrophic_lateral_sclerosis_discovery.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2016/2016_van_Rheenen/ALSmeta.txt.gz
gzip -cd ALSmeta.txt.gz > ALSmeta.txt
cp ALSmeta.txt  27455348_Amyotrophic_lateral_sclerosis_meta.txt