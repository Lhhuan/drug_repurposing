wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2016/2016_Middeldorp/ADHD_middeldorp_GC1.gz
#wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2016/2016_Middeldorp/ADHD_middeldorp_noGC1.gz
#zcat ADHD_middeldorp_GC1.gz ADHD_middeldorp_noGC1.gz > ADHD.txt
gzip -cd ADHD_middeldorp_GC1.gz > ADHD_middeldorp_GC1.txt
cp ADHD_middeldorp_GC1.txt 27663945_Childhood_attention-deficit_or_hyperactivity_disorder\(ADHD\).txt
