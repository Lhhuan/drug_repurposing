# wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/OkbayA_27089181_GCST003766/SWB_Full.txt.gz
# gzip -cd SWB_Full.txt.gz > SWB_Full.txt
# cp SWB_Full.txt 27089181_Subjective_well-being.txt
#wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/OkbayA_27089181_GCST003770/Neuroticism_Full.txt.gz
gzip -cd Neuroticism_Full.txt.gz > Neuroticism_Full.txt
cp Neuroticism_Full.txt 27089181_Neuroticism.txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/OkbayA_27089181_GCST003769/DS_Full.txt.gz
gzip -cd DS_Full.txt.gz > DS_Full.txt
cp DS_Full.txt 27089181_Depression.txt