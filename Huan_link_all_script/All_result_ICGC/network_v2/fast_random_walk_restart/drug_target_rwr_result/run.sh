#得到../04_test_start_end_num_sorted.txt为start和end的pair
#对每个参数，每个start对应end result进行排序，取$top,得文件$sort_top_file， $top里的结果再与end取交集。所有重合的数据为param_top_probability/01_top_${top_p}_${parameter}_probability.txt
#然后查看param_top_probability/01_top_${top_p}_${parameter}_probability.txt的行数，输出到文件$final_parameter_result.txt里面。
#../start_drug_target_network_num_final.txt"; #输入的是start(drug_target)为start，"../somatic_uni_entrez_num.txt"为end，对每个start对应的文件进行排序，然后取$top*12277;然后用这些点和end取交集。 

perl 01_get_drug_target_rwr_result.pl
cat drug-target_somatic-gene.txt | perl -ane 'chomp;unless(/^drug_target/){@f=split/\t/;print "$f[1]\n";}'| sort -u > rwr_hit_unique_somatic_gene.txt