# Rscript fisher_test.R #对02_drug_hit_repo_and_gene-count_prepare_fisher.txt进行fisher检验，得到文件fisher_test_result.txt
# cat fisher_test_result.txt | perl -ane 'chomp; @f= split/\t/;if($f[3]<0.05){print "$_\n"}' >fisher_test_result_p_small_than0.05.txt
# perl 02_cutoff_p_significant_count.pl #把不同cutoff时，p值显著的drug repo pair计数。得文件02_cutoff_p_significant_count.txt

# cat 02_cutoff_p_significant_count.txt | sort -k1,1g > 02_sorted_cutoff_p_significant_count.txt

Rscript fisher_test.R #得到文件"/media/mulinlab/Data02/huan/All_result/network/random_walk_restart/parameter_optimization/top/hit_result/fisher_test_result.txt"
cat fisher_test_result.txt | perl -ane 'chomp; @f= split/\t/;if($f[3]<0.05){print "$_\n"}' >fisher_test_result_p_small_than0.05.txt #得P<0.05的文件fisher_test_result_p_small_than0.05.txt

cat "/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt" | cut -f1,5 | sort -u | wc -l #250-1 =249行，也就是原来的drug repo pair共249行
perl 02_cutoff_p_significant_count.pl ##把不同cutoff时，p值显著的drug repo pair计数。得文件02_cutoff_p_significant_count.txt
cat 02_cutoff_p_significant_count.txt | sort -k1,1g > 02_sorted_cutoff_p_significant_count.txt #按照cutoff从低到高排序
#以02_sorted_cutoff_p_significant_count.txt的cutoff为横坐标，count为纵坐标作图，得02_sorted_cutoff_p_significant_count_map.xlsx，图在sheet1，图并不显著，所以把把02_cutoff_p_significant_count.txt的count值从大到小排序

cat 02_cutoff_p_significant_count.txt | sort -k2,2rg > 02_sorted_count__cutoff_p_significant_count.txt  #把02_cutoff_p_significant_count.txt的count值从大到小排序。得到文件02_sorted_count__cutoff_p_significant_count.txt
#发现cutoff 为 0.044 0.0441 0.0442 0.0439时，drug repo pair最高，为185,,百分比为74.30所以最终选0.044为cutoff
cat "/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt" | cut -f1,5 | sort -u | wc -l #250-1 =249行，也就是原来的drug repo pair共249行 
