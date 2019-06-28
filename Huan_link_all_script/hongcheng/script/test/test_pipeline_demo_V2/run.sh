vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i demo.vcf --cache --offline -o test_vep.vcf --uniprot --gene --symbol --biotype
bash missense_varient_predict.sh
bash lof_variant.sh

perl 01_merge_missense_and_lof_moa.pl #将./B_sift_tmp/missense_match_bscore.txt 中的LOF 和GOF 区分出来，并和./B_sift_tmp/varient_lof.txt merge 到一起，得./output/01_merge_missense_and_lof_vraint_moa.txt
perl 02_merge_mutation_gene_MOA_and_cancer.pl #将./output/01_merge_missense_and_lof_vraint_moa.txt 和"/f/mulinlab/huan/hongcheng/output/10_normal_three_source_cancer_gene_lable.txt merge 到一起，
#得./output/02_merge_mutation_gene_MOA_and_cancer.txt
#----------------------gene-based
perl 03_gene_based_merge_mutation_gene_MOA_cancer_drug.pl #将通过cancer gene 和 drug target 将mutation 和drug link 起来。即./output/02_merge_mutation_gene_MOA_and_cancer.txt 和
#"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score_bioactivities.txt" merge 到一起，得./output/03_gene_based_merge_mutation_gene_MOA_cancer_drug.txt
perl 04_judge_gene_based_logic_mutation_cancer_gene_and_drug_target.pl #判断./output/03_gene_based_merge_mutation_gene_MOA_cancer_drug.txt中突变，癌症基因和药物靶点的逻辑，
#得总文件./output/04_judge_gene_based_logic_mutation_cancer_gene_and_drug_target.txt
#得逻辑正确文件./output/04_judge_gene_based_mutation_cancer_gene_and_drug_target_logic_true.txt
#得逻辑错误文件./output/04_judge_gene_based_mutation_cancer_gene_and_drug_target_logic_conflict.txt
#得没有逻辑文件./output/04_judge_gene_based_mutation_cancer_gene_and_drug_target_logic_no.txt

#----------------------------------network-based
perl 05_network_based_merge_mutation_gene_MOA_cancer_drug.pl # cp "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/11_find_cancer_for_drug.pl"
##利用/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/9.27_merge_drug_target_network_gene_normal_score.txt和"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/output/network_gene_num.txt"
#和突变与癌症关系的文件./output/02_merge_mutation_gene_MOA_and_cancer.txt
#得与mutation和drug关系的文件./output/05_network_drug_mutation.txt,得没有mutation 对应的gene 文件./output/05_no_mutation_cancer_entrez.txt
perl 06_merge_drug_info.pl #cp "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/12_merge_drug_indication_cancer.pl"
##利用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score_bioactivities.txt和./output/05_network_drug_mutation.txt 联系起来，把drug原来的indication等信息加过来，
#得./output/06_mutation_network_drug_indication_cancer.txt.gz
perl 07_merge_drug_target_network_id_success_pair_info.pl  #"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/15.1_merge_drug_target_network_id_success_pair_info.pl"
#用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/output/network_gene_num.txt"把./output/06_mutation_network_drug_indication_cancer.txt.gz中的 drug entrze id 转化成在网络中的编号。
#得./output/07_merge_drug_target_network_id_success_pair_info.txt.gz
perl 08_judge_mutation_drug_target_network_based_logic.pl   #cp "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/16_merge_logic_shortest_path_cancer_gene_drug_moa_and_judge_logic.pl"
##把网络最短路径的文件/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/10_start_end_logical.txt及./output/07_merge_drug_target_network_id_success_pair_info.txt.gz merge在一起，
#并判断最短路径的逻辑和drug target 和cancer gene的逻辑，得逻辑一致的文件./output/08_judge_mutation_drug_target_network_based_logic_true.txt.gz,得逻辑不一致的文件./output/08_judge_mutation_drug_target_network_based_logic_conflict.txt.gz,
#得没有逻辑的文件./output/08_judge_mutation_drug_target_network_based_no_logic.txt.gz,####得总文件./output/08_judge_mutation_drug_target_network_based_logic.txt.gz
#---------------------------------
#-----------------------------------merge network-based and gene-based data


perl 09_merge_gene-based_and_network-based_mutation_drug.pl #将./output/04_judge_gene_based_logic_mutation_cancer_gene_and_drug_target.txt 和./output/08_judge_mutation_drug_target_network_based_logic.txt.gz merge 到一起，
#得./output/09_merge_gene-based_and_network-based_mutation_drug.txt.gz