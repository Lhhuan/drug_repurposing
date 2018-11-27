wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Shungin/WC.zip
unzip WC.zip
gzip -cd  WC/GIANT_2015_WC_COMBINED_AllAncestries.txt.gz  > 25673412_Waist_circumference.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Shungin/HIPadjBMI.zip
unzip HIPadjBMI.zip
gzip -cd  HIPadjBMI/GIANT_2015_HIPadjBMI_COMBINED_AllAncestries.txt.gz > 25673412_Hip_adjusted_for_body_mass_index.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Shungin/WHR.zip
unzip WHR.zip
gzip -cd WHR/GIANT_2015_WHR_COMBINED_AllAncestries.txt.gz > 25673412_Waist_hip_ratio.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Shungin/WHRadjBMI.zip
unzip WHRadjBMI.zip
gzip -cd  WHRadjBMI/GIANT_2015_WHRadjBMI_COMBINED_AllAncestries.txt.gz > 25673412_Waist_hip_ratio_adjusted_for_body_mass_index.txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Shungin/HIP.zip
unzip HIP.zip 
gzip -cd  HIP/GIANT_2015_HIP_COMBINED_AllAncestries.txt.gz > 25673412_Hip.txt
wget -chttps://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Shungin/WCadjBMI.zip
unzip WCadjBMI.zip
gzip -cd WCadjBMI/GIANT_2015_WCadjBMI_COMBINED_AllAncestries.txt.gz > 25673412_waist-to-hip_ratio_adjusted_for_body_mass_index.txt