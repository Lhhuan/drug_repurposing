#wget http://csg.sph.umich.edu/abecasis/public/lipids2013/jointGwasMc_HDL.txt.gz
gzip -cd jointGwasMc_HDL.txt.gz > jointGwasMc_HDL.txt
cp jointGwasMc_HDL.txt 20686565_HDL_cholesterol.txt
wget http://csg.sph.umich.edu/abecasis/public/lipids2013/jointGwasMc_LDL.txt.gz
gzip -cd jointGwasMc_LDL.txt.gz > jointGwasMc_LDL.txt
cp jointGwasMc_LDL.txt 20686565_LDL_cholesterol.txt
wget http://csg.sph.umich.edu/abecasis/public/lipids2013/jointGwasMc_TG.txt.gz 
gzip -cd jointGwasMc_TG.txt.gz > jointGwasMc_TG.txt
cp jointGwasMc_TG.txt 20686565_Triglycerides.txt
wget  http://csg.sph.umich.edu/abecasis/public/lipids2013/jointGwasMc_TC.txt.gz
gzip -cd jointGwasMc_TC.txt.gz > jointGwasMc_TC.txt
cp jointGwasMc_TC.txt 20686565_Total_Cholesterol.txt

