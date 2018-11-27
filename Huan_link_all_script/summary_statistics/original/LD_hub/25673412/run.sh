wget http://portals.broadinstitute.org/collaboration/giant/images/e/e4/GIANT_2015_HIP_COMBINED_EUR.txt.gz 
gzip -cd GIANT_2015_HIP_COMBINED_EUR.txt.gz > GIANT_2015_HIP_COMBINED_EUR.txt
cp GIANT_2015_HIP_COMBINED_EUR.txt 25673412_Hip_circumference.txt
wget http://portals.broadinstitute.org/collaboration/giant/images/5/57/GIANT_2015_WC_COMBINED_EUR.txt.gz
gzip -cd GIANT_2015_WC_COMBINED_EUR.txt.gz >GIANT_2015_WC_COMBINED_EUR.txt
cp GIANT_2015_WC_COMBINED_EUR.txt 25673412_Waist_circumference.txt
wget http://portals.broadinstitute.org/collaboration/giant/images/5/54/GIANT_2015_WHR_COMBINED_EUR.txt.gz
gzip -cd GIANT_2015_WHR_COMBINED_EUR.txt.gz > GIANT_2015_WHR_COMBINED_EUR.txt
cp GIANT_2015_WHR_COMBINED_EUR.txt 25673412_Waist-to-hip_ratio.txt