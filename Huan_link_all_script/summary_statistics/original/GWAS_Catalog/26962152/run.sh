for k in $(seq 1 6)
do 
    wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/OffenbacherS_26962152_GCST003484/Offenbacher-26962152_pct${k}.txt
done
cat Offenbacher*.txt > Offenbacher-26962152_pct.txt
cp Offenbacher-26962152_pct.txt 26962152_Periodontal_disease-related_phenotypes.txt