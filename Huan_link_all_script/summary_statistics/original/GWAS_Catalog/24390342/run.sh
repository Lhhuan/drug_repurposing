wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/OkadaY_24390342_GCST002318/RA_GWASmeta_TransEthnic_v2.txt.gz
gzip -cd RA_GWASmeta_TransEthnic_v2.txt.gz > RA_GWASmeta_TransEthnic_v2.txt
cp RA_GWASmeta_TransEthnic_v2.txt 24390342_Rheumatoid_arthritis.txt