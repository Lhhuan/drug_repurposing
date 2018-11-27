wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/OkbayA_27225129_GCST003676/Okbay_27225129-EduYears_Main.txt.gz
gzip -cd Okbay_27225129-EduYears_Main.txt.gz > Okbay_27225129-EduYears_Main.txt
cp Okbay_27225129-EduYears_Main.txt 27225129_Educational_attainment_\(years_of_education\).txt
