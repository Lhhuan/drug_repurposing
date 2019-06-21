#cat ./tmp_shortest_path_data/09_the_shortest_path*.txt >09_the_shortest_path.txt
# cat ./9.25_random_overlap_fact/output/9.25_random_overlap_fact*.txt > 9.25_random_overlap_fact.txt
# perl 9.26_count_random_overlap_fact.pl
# echo -e "finish_9.26_count_random_overlap_fact\n"
perl 9.27_merge_drug_target_network_gene_normal_score.pl
echo -e "finish_9.27_merge_drug_target_network_gene_normal_score\n"
perl 10_find_logic_of_the_shortest.pl
echo -e "finish_10_find_logic_of_the_shortest\n"
perl 11_find_cancer_for_drug.pl
echo -e "finish_11_find_cancer_for_drug\n"
perl 12_merge_drug_indication_cancer.pl
echo -e "12_merge_drug_indication_cancer\n"
perl 15.1_merge_drug_target_network_id_success_pair_info.pl
echo -e "finish_15.1_merge_drug_target_network_id_success_pair_info\n"
perl 16_merge_logic_shortest_path_cancer_gene_drug_moa_and_judge_logic.pl
echo -e "finish_16_merge_logic_shortest_path_cancer_gene_drug_moa\n"