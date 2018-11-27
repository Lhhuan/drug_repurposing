cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/09_somatic_snv_indel_mutationID_ensg_entrez.txt" ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/ID_project.txt" ICGC_occurthan1_snv_indel_mutationID_project.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/cancer_id_full_oncotree.txt" ICGC_occurthan1_snv_indel_project_oncotree.txt
cat ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt| perl -ane 'chomp;unless(/^Mutation_ID/){@f = split/\t/;print "$f[1]\n"}' | sort -u > unique_ICGC_occurthan1_snv_indel.txt 
perl 10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.pl
perl 11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.pl
perl 12_merge_ICGC_info_gene_role.pl
perl 13_merge_cancer_gene_drug_information.pl
perl 15_merge_cancer_gene_drug_indication_oncotree.pl
perl 16_judge_gene_based_somatic_repo_success.pl
cat 16_gene_based_ICGC_somatic_repo_fail.txt | cut -f10,38 > 16_gene_based_ICGC_somatic_repo_fail_drug_disease.txt
perl 21_merge_drug_info_do_hpo_oncotree.pl
perl 16.1_filter_all_drug_indication_in_icgc_project.pl
cat 16.1_drug_cancer_in_icgc_project.txt | cut -f1 | sort -u > occur_orignal_drug.txt
perl 17_filter_indication_from_cancer.pl
perl 18_filter_success_pair_info.pl
perl 19_judge_ICGC_Indel_SNV_logic.pl
perl 20_filter_may_success_repo_cancer.pl
