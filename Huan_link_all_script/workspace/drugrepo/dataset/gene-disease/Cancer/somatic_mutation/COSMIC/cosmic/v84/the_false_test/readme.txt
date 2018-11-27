nohup /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicCodingMuts.vcf.gz  -o CosmicCodingMuts_vep.vcf --cache --offline --fork 8  --symbol --gene  > nohup.out &



gzip -cd CosmicSample.tsv.gz > CosmicSample.tsv
01_merge_coding_and_noncoding.pl 把coding的tsv文件CosmicMutantExport.tsv.gz（带有variant id 和id_tumor）和noncoding文件CosmicNCV.tsv.gz merge 起来，得文件01_merge_coding_and_noncoding_id_tumor.txt
02_connect_id-tumor_nci-code.pl 把01_merge_coding_and_noncoding_id_tumor.txt和CosmicSample.tsv.gz以及classification.csv联系起来，得到mutation_id-id-tumour_nci-code_efo的关系，得文件02_mutation_id-id-tumour_nci-code_efo.txt
#02_connect_id-tumor_nci-code.pl的逻辑有可能错误，现在不要cancer的efo和nci_code,直接从coding的tsv文件CosmicMutantExport.tsv.gz和noncoding文件CosmicNCV.tsv.gz merge 起来。
03_merge_coding_and_noncoding_id_tumor_and_other_info.pl 把coding的tsv文件CosmicMutantExport.tsv.gz（带有variant id 和id_tumor）和noncoding文件CosmicNCV.tsv.gz merge 起来，得文件01_merge_coding_and_noncoding_id_tumor.txt的部分信息merge在一起。
