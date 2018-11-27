perl filter_pathogenicity_mutation_cancer.pl #用../12_merge_ICGC_info_gene_role.txt
#和"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/cadd_score/SNV_Indel_cadd_score.vcf" 文件，得CADD score >15 的variant 及其对应的基因信息。
#得pathogenicity_mutation_cancer.txt，得所有的cadd>15的mutation id文件pathogenicity_mutation_ID.txt
    perl pathogenicity_15_occur_more_than2.pl #统计"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/cadd_score/SNV_Indel_cadd_score.vcf" 中CADD score 大于15，occurance 大于2的mutationID 的数目。
    #得pathogenicity_15_occur_more_than2.txt ,在cancer中没有的mutation ID 文件cadd_morethan15_occur_morethan2_but_not_cancer_mutation_id.txt，在cancer中没有的mutation ID 等其他信息的文件cadd_morethan15_occur_morethan2_but_not_cancer_infos.txt，这里面的每个cancer对应的affected_donor 都小于2
    #

