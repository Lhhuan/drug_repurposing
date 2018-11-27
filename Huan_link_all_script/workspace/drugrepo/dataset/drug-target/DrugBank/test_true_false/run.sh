cat ../step2_result_gene_drug.txt | cut -f3 | sort -u >before_uniprot_id.txt #2296-1 =2295行。
cat ../step2_result_gene_drug.txt |cut -f14 | sort -u > before_drug_num.txt #4867 -1 =4866
cat ../getfromdrugbank2017-12-18.txt |cut -f4 | sort -u >original_uniprot_id.txt #4335 -1 = 4334行。
perl test_uniprot_to_ensg.pl #把original_uniprot_id.txt 和ensemble（用hg38下载，Gene stable ID， UniProtKB/Swiss-Prot ID，UniProtKB/TrEMBL ID）来源的mart_export.txt进行匹配，得uniprot_ENSG.txt
cat uniprot_ENSG.txt | cut -f1 | sort -u >ensemble_uniprot_id.txt #2488-1 = 2487
perl step2_refine.pl #把../step 进行refine，把enst push 进以uniprot_id为hash key 的数组。得step2_result_gene_drug.txt
cat step2_result_gene_drug.txt | cut -f3 | sort -u >refine_uniprot_id.txt #2447 -1 =2446 
cat step2_result_gene_drug.txt |cut -f14 | sort -u > refine_drug_num.txt #5053-1 = 5052 
