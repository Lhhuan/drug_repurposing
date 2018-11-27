wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/LemmelaS_27764105_GCST003869/LemmelaS_27764105journal.pone.0163877.s001
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/LemmelaS_27764105_GCST003869/LemmelaS_27764105journal.pone.0163877.s002
cat LemmelaS_27764105journal* > LemmelaS_27764105journal.pone.txt
cp LemmelaS_27764105journal.pone.txt 27764105_Sciatica.txt