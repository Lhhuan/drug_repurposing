for k in $(seq 1 22)
do 
    wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/JinY_27723757_GCST004785/GWAS123chr${k}cmh.txt.gz
done
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/JinY_27723757_GCST004785/GWAS123chrXcmh.txt.gz
zcat GWAS*.txt.gz > GWAS123cmh.txt
cp GWAS123cmh.txt  27723757_Vitiligo.txt