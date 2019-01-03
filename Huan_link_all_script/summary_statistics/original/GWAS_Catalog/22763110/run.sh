wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/ZegginiE_22763110_GCST001592/Zeggini_22763110_HapMapIII_knee-and-or-hip-OA-all-7410cases-11009controls.txt.gz
gzip -cd Zeggini_22763110_HapMapIII_knee-and-or-hip-OA-all-7410cases-11009controls.txt.gz > Zeggini_22763110_HapMapIII_knee-and-or-hip-OA-all-7410cases-11009controls.txt
cp Zeggini_22763110_HapMapIII_knee-and-or-hip-OA-all-7410cases-11009controls.txt 22763110_Osteoarthritis.txt
sed -i 's/,/\t/' 22763110_Osteoarthritis.txt
