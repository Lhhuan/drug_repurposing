wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Scott/MAGIC_Scott_Metabochip_Public_data_release_25Jan.zip
unzip MAGIC_Scott_Metabochip_Public_data_release_25Jan.zip
cp MAGIC_Scott_et_al_FG_Jan2013.txt  22885924_Fasting_glucose\(metabochip\).txt
cat MAGIC_Scott_et_al_FI_adjBMI_Jan2013.txt MAGIC_Scott_et_al_FI_Jan2013.txt > 22885924_Fasting_insulin\(metabochip\).txt