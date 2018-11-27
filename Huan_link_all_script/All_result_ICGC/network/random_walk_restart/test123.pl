##把网络最短路径的文件10_start_end_logical.txt及15.1_merge_drug_target_network_id_success_pair_info.txt merge在一起，得文件16_merge_logic_shortest_path_cancer_gene_drug_moa.txt（因为测试过中间文件很大，所以就不输出了，直接对其判断逻辑）
#并判断最短路径的逻辑和drug target 和cancer gene的逻辑，得逻辑一致的文件16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt,得逻辑不一致的文件16_judge_the_shortest_drug_target_cancer_gene_logic_conflict.txt,
#得没有逻辑的文件16_judge_the_shortest_drug_target_cancer_gene_no_logic.txt,####得总文件16_judge_the_shortest_drug_target_cancer_gene_logic.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  


print "123\n";