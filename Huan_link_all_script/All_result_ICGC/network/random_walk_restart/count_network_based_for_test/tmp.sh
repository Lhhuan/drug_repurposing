# perl 12_merge_drug_indication_cancer.pl
# echo -e "12_merge_drug_indication_cancer\n"
# perl 13_judge_network_based_somatic_repo_success.pl
# echo -e "finish_13_judge_network_based_somatic_repo_success\n"
# perl 14_filter_indication_from_cancer.pl
# echo -e "finish_14_filter_indication_from_cancer\n"
# perl 15_filter_success_pair_info.pl
# echo -e "finish_15_filter_success_pair_info\n"
perl 15.1_merge_drug_target_network_id_success_pair_info.pl
echo -e "finish_15.1_merge_drug_target_network_id_success_pair_info\n"
perl 16_merge_logic_shortest_path_cancer_gene_drug_moa_and_judge_logic.pl
echo -e "finish_16_merge_logic_shortest_path_cancer_gene_drug_moa\n"