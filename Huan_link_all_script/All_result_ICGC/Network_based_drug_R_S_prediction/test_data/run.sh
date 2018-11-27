#-------------------------------------------------------------筛选正负样本
cp "/f/mulinlab/huan/All_result_ICGC/Gene-based_drug_R_or_S_optimization/side_effect_repo_data/0311_filter_cancer_from_repoDB_approved.txt" ./output/cancer_from_repoDB_approved.txt
cat ./output/cancer_from_repoDB_approved.txt | cut -f2 | sort -u >./output/unique_cancer_term_from_repoDB_approved.txt
#将unique_cancer_term_from_repoDB_approved.txt映射到oncotree,得./output/unique_cancer_term_from_repoDB_approved_oncotree.txt
perl 001_merge_repoDB_oncotree.pl #把./output/cancer_from_repoDB_approved.txt 和./output/unique_cancer_term_from_repoDB_approved_oncotree.txt merge 在一起，得001_merge_repoDB_oncotree.txt
perl 002_extract_drug_info_for_repo_data.pl #在../all_drug_infos_score.txt中提取./output/001_merge_repoDB_oncotree.txt中的drug target 及其score等信息，得./output/002_drug_info_repo.txt,得具有以上的信息的文件./output/002_uni_drug_repo.txt
perl 003_merge_repo_cancer_gene.pl #用../../pathogenicity_mutation_cancer/pathogenicity_mutation_cancer.txt 将./output/012_drug_info_repo.txt中cancer 相关信息提出来，得./output/003_merge_repo_drug_cancer_gene.txt
perl 004_merge_two_source_data.pl #把./output/003_merge_repo_drug_cancer_gene.txt 和"/f/mulinlab/huan/All_result_ICGC/Gene-based_drug_R_or_S_optimization/side_effect_repo_data/06_merge_repo_side-effect_cancer_gene.txt" 
#merge 成一个文件，得./output/004_merge_two_source_drug_cancer_info.txt
perl 01_judge_drug_target_and_cancer_differ.pl #判断"./output/004_merge_two_source_drug_cancer_info.txt"
#中的drug target和cancer gene是否是同一基因，得01_drug_taregt_cancer_gene_same.txt,得drug target和cancer gene 完全不相同的文件01_drug_taregt_cancer_gene_differ.txt
