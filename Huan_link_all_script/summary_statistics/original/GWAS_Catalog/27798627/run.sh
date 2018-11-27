wget ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/BarbanN_27798627_GCST003795/AgeFirstBirth_Female.txt.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/BarbanN_27798627_GCST003795/AgeFirstBirth_Male.txt.gz
zact AgeFirstBirth_Female.txt.gz AgeFirstBirth_Male.txt.gz > AgeFirstBirth.txt
cp AgeFirstBirth.txt 27798627_Age_at_first_birth.txt
wget ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/BarbanN_27798627_GCST003795/NumberChildrenEverBorn_Female.txt.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/BarbanN_27798627_GCST003795/NumberChildrenEverBorn_Male.txt.gz
zact NumberChildrenEverBorn_Female.txt.gz NumberChildrenEverBorn_Male.txt.gz > NumberChildrenEverBorn.txt
cp NumberChildrenEverBorn.txt 27798627_Number_of_children_ever_born.txt