wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2017/2017_Kim_ACL_Achilles/ACLSummary3.txt.zip
gzip -cd ACLSummary3.txt.zip > ACLSummary3.txt
cp ACLSummary3.txt 28358823_ACL_injury.txt
gzip -cd AchillesSummary.txt.zip > AchillesSummary.txt
cp AchillesSummary.txt  28358823_Achilles_heel_injury.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2017/2017_Kim_Ankle_Injury/Ankle3b_META_sort.txt.zip
gzip -cd Ankle3b_META_sort.txt.zip > Ankle3b_META_sort.txt
cp Ankle3b_META_sort.txt 28957384_Ankle_injury.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2017/2017_Kim_Plantar_fasciitis/PlantarSummary.txt.zip
gzip -cd PlantarSummary.txt.zip > PlantarSummary.txt
cp PlantarSummary.txt 28957384_Plantar_fasciitis.txt