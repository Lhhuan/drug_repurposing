#从pmid为23928289中收集repo_cancer的数据得./output/23928289repo.txt
perl 01_handle_23928289repo.pl #将./output/23928289repo.txt中的分号等去掉，并把drug 和repo cancer 分开输出得./output/01_handle_23928289repo.txt，得unique的cancer文件./output/01_23928289_unique_cancer.txt
#将./output/01_23928289_unique_cancer.txt map 到oncotree上http://oncotree.mskcc.org/#/home ，得./output/01_23928289_unique_cancer_oncotree.txt
perl 02_merge_cancer_oncotree.pl #把./output/01_23928289_unique_cancer_oncotree.txt 和 ./output/01_handle_23928289repo.txt merge 在一起，得./output/02_23928289_repo_cancer.txt
perl 03_23928289repo_overlap_repurposing_result.pl #看../huan_data/output/09_repurposing_Drug_claim_primary_name.txt 中除去在训练集../test_data/output/09_filter_test_data_for_logistic_regression.txt 中
#出现的drug cancer pair,与./output/02_23928289_repo_cancer.txt 的overlap 得./output/03_23928289repo_overlap_repurposing_result.txt