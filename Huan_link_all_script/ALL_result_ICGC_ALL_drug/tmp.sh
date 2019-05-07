cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/all_somatic_snv_indel_mutationID_ensg_entrez.txt" ./output/ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics//Pathogenicity_id_project.txt" ./output/ICGC_occurthan1_snv_indel_mutationID_project.txt  #这个是mutation occur >1的cancer。
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/cancer_id_full_oncotree1.txt" ./output/ICGC_occurthan1_snv_indel_project_oncotree.txt
cat ./output/ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt| perl -ane 'chomp;unless(/^Mutation_ID/){@f = split/\t/;print "$f[1]\n"}' | sort -u > ./output/unique_ICGC_occurthan1_snv_indel.txt

perl 10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.pl
echo -e "10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene\n"
perl 11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.pl
echo -e "11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree\n"
perl 12_merge_ICGC_info_gene_role.pl
echo -e "12_merge_ICGC_info_gene_role\n"
perl 13_merge_cancer_gene_drug_information.pl
echo -e "13_merge_cancer_gene_drug_information\n"
perl 15_merge_cancer_gene_drug_indication_oncotree.pl
echo -e "15_merge_cancer_gene_drug_indication_oncotree\n"
perl 21_merge_drug_info_do_hpo_oncotree.pl
echo -e "21_merge_drug_info_do_hpo_oncotree\n"
perl 19_judge_ICGC_Indel_SNV_logic.pl 
echo -e "19_judge_ICGC_Indel_SNV_logic\n"

perl merge_huan_drug_target_score.pl

echo -e "merge_huan_drug_target_score\n"