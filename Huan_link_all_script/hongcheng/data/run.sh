ln "/f/mulinlab/zhouyao/VarNoteDB/VarNoteDB_v1.0/FA/VarNoteDB_FA_dbNSFP_v3.5a/VarNoteDB_FA_dbNSFP_v3.5a.gz" ./

#wget cancer_gene_census.csv from COSMIC V89 GRCH37, 并另存为cancer_gene_census.txt

wget https://oncokb.org/api/v1/utils/cancerGeneList.txt #1134 genes, last update May 9, 2019 , Cancer Gene Census:  Gene is part of the Cancer Gene Census(cosmic) (723 genes, 05/07/2019)
mv cancerGeneList.txt oncokb_cancerGeneList.txt

# wget -c https://zenodo.org/record/2662509/files/cancermine_collated.tsv?download=1 
# mv cancermine_collated.tsv?download=1 cancermine_collated.tsv
ln /f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/cancermine_collated_and_ensg_symbol.txt ./