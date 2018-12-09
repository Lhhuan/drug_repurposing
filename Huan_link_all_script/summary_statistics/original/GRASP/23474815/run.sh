wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/Stambolian/Stambolianmeta.zip
unzip  Stambolianmeta.zip
cat Stambolianmeta/supp_ddt116_Stambolian_RE_meta_chr*.csv > Visual_refractive_error.csv
cp Visual_refractive_error.csv 23474815_Visual_refractive_error.csv
