wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/HammerschlagAR_28604731_GCST004695/Hammerschlag_NatGenet2017_insomnia_sumstats-full_090617.txt.gz
gzip -cd Hammerschlag_NatGenet2017_insomnia_sumstats-full_090617.txt.gz > Hammerschlag_NatGenet2017_insomnia_sumstats-full_090617.txt
cp Hammerschlag_NatGenet2017_insomnia_sumstats-full_090617.txt 28604731_Insomnia_complaints.txt