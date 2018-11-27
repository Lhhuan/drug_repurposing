wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/International_League_Against_Epilepsy_Consortium_on_Complex_Epilepsies/ILAE_All_Epi_11.8.14.txt.gz
gzip  -cd ILAE_All_Epi_11.8.14.txt.gz > ILAE_All_Epi_11.8.14.txt
cp ILAE_All_Epi_11.8.14.txt 25087078_Epilepsy.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/International_League_Against_Epilepsy_Consortium_on_Complex_Epilepsies/ILAE_Focal_5.8.14.txt.gz
gzip -cd ILAE_Focal_5.8.14.txt.gz > ILAE_Focal_5.8.14.txt
cp ILAE_Focal_5.8.14.txt 25087078_Focal_epilepsy.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/International_League_Against_Epilepsy_Consortium_on_Complex_Epilepsies/ILAE_GGE_5.8.14.txt.gz
gzip -cd ILAE_GGE_5.8.14.txt.gz > ILAE_GGE_5.8.14.txt
cp ILAE_GGE_5.8.14.txt 25087078_Genetic_generalized_epilepsy.txt