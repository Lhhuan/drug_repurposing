
perl 01_logic_true_repo_drug_count.pl #记录../../uniq_logic_true_repo_drug_pair.txt 里每个repo 从cancer 所对应的drug 数目，得文件logic_true_repo_drug_count.txt
Rscript logic_true_repo_drug_count.R #画图
perl 02_repo_fail_drug_count.pl #记录../../17_drug_repo_cancer_pairs_may_fail.txt 里每个drug repo 到的cancer，与其原本indication的overlap. 得02_repo_fail_drug_count.txt