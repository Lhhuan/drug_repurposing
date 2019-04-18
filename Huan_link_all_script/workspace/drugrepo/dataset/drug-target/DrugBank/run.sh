python getfromdrugbank2017-12-18.py #将drugbank中的一系列drug找出来，得getfromdrugbank2017-12-18.txt  getfromdrugbank2017-12-18.txt中有些行多出table，手动删除得getfromdrugbank2017-12-18_refine.txt
perl step2.pl #用将得getfromdrugbank2017-12-18_refine.txt的结果中的uniprotid 和ensGene和wgEncodeGencodeUniProtV24lift37.txt 联系起来，得到uniprot-id, ENSGid和ENSTid 的关系。
   #在（http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/）中下载的ensGene（ENSGid与ENSTid的关系）和wgEncodeGencodeUniProtV24lift37.txt （包含uniprot和ENSTid的关系）。
   # ensGene和wgEncodeGencodeUniProtV24lift37.txt 联系起来，得到uniprot-id, ENSGid和ENSTid 的关系。得文件step2_result_gene_drug.txt。
Rscript step3.R #对getfromdrugbank2017-12-18_refine.txt中的ENSG00000000938转换为entrezgene。得出transform.txt
perl step4.pl #将得出的transform.txt和step2_result_gene_drug.txt匹配进行。匹配成功得step4_drugbank_drug_gene_entrez_id.txt，不成功的以NA输出到step4_drugbank_drug_gene_entrez_id.txt，同时匹配不成功得step4_unmatch_ensg.txt。
cat step4_drugbank_drug_gene_entrez_id.txt | cut -f15| sort -u >uni_drug.txt #5053-1 =5052