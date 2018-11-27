wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/PhelanCM_28346442_GCST004417/Phelan_Archive.zip
unzip Phelan_Archive.zip
cat Summary_chr1.txt| perl -ane 'chomp;@f =split/\t/;$k= join(",",@f[0..$#f]);print "$k\n"; ' > Summary_chr1_notab.txt
cat Summary_chr7.txt| perl -ane 'chomp;@f =split/\t/;$k= join(",",@f[0..$#f]);print "$k\n"; ' > Summary_chr7_notab.txt

mv Summary_chr1.txt Summary_1.txt
mv Summary_chr7.txt Summary_7.txt

cat Summary_chr*.txt > Summary.txt
cp Summary.txt 28346442_Ovarian_clear_cell_cancer.txt