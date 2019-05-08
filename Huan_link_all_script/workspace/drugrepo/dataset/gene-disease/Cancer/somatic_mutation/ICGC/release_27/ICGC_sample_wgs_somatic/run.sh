perl 01_merge_all_sample_mutation.pl #将./icgc_sample_data下的所有文件夹下的文件合在一起，得./output/01_all_sample_mutation.txt
perl 02_merge_mutation_donor_project.pl #将mutation_donor_project merge在一起。将./output/01_all_sample_mutation.txt 和./output/manifest.collaboratory.1556157173216.tsv merge 到一起，
#得./output/02_merge_mutation_donor_project.txt.gz
perl 03_filter_pathogenicity_sample_data.pl #利用../release_27_snv_indel/data_statistics/pathogenicity_mutation_postion.txt 筛选出./output/02_merge_mutation_donor_project.txt.gz的致病性突变
#得./output/03_pathogenicity_sample_data.txt
perl 04_merge_pathogenicity_sample_oncotree_term.pl #把./output/03_pathogenicity_sample_data.txt和 ../release_27_snv_indel/data_statistics/cancer_id_full_oncotree1.txt merge 在一起，
#得./output/04_pathogenicity_sample_oncotree.txt
perl 05_count_pathogenicity_mutation_number_in_cancer_in_sample_level.pl #利用./output/04_pathogenicity_sample_oncotree.txt 计算每个cancer中在sample level的平均致病性突变数目，
#得文件./output/05_ICGC_pathogenicity_mutation_number_in_cancer_in_sample_level.txt