vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i demo.vcf --cache --offline -o test_vep.vcf --uniprot --gene --symbol --biotype --force_overwrite
bash missense_varient_predict.sh
bash lof_variant.sh
perl 01_merge_missense_and_lof_moa.pl #将./B_sift_tmp/missense_match_bscore.txt 中的LOF 和GOF 区分出来，并和./B_sift_tmp/varient_lof.txt merge 到一起，得./output/01_merge_missense_and_lof_vraint_moa.txt
echo -e "finish_01_merge_missense_and_lof_moa\n"
perl 02_merge_mutation_gene_MOA_and_cancer.pl #将./output/01_merge_missense_and_lof_vraint_moa.txt 和"/f/mulinlab/huan/hongcheng/output/10_normal_three_source_cancer_gene_lable.txt merge 到一起，
echo -e "finish_02_merge_mutation_gene_MOA_and_cancer\n"
perl 03_gene_based_merge_mutation_gene_MOA_cancer_drug.pl 
echo -e "finish_03_gene_based_merge_mutation_gene_MOA_cancer_drug\n"
perl 04_judge_gene_based_logic_mutation_cancer_gene_and_drug_target.pl 
echo -e "finish_04_judge_gene_based_logic_mutation_cancer_gene_and_drug_target\n"
perl 05_network_based_merge_mutation_gene_MOA_cancer_drug.pl
echo -e "finish_05_network_based_merge_mutation_gene_MOA_cancer_drug\n"
perl 06_merge_drug_info.pl
echo -e "finish_06_merge_drug_info\n"
perl 07_merge_drug_target_network_id_success_pair_info.pl
echo -e "finish_07_merge_drug_target_network_id_success_pair_info\n"
perl 08_judge_mutation_drug_target_network_based_logic.pl
echo -e "finish_08_judge_mutation_drug_target_network_based_logic\n"
# perl 09_merge_gene-based_and_network-based_mutation_drug.pl
# echo -e "finish_09_merge_gene-based_and_network-based_mutation_drug\n"