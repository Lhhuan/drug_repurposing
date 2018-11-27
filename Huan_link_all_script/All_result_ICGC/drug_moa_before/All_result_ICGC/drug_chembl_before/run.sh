cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/step10-3_all_target_drug_indication.txt" DGIdb_all_target_drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/mapin_ontology/human_phenotype_ontology/step10-4_unique_indication-id.txt" DGIdb_used_mapin.txt #并手动为DGIdb_used_mapin.txt添加header
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/mapin_ontology/human_phenotype_ontology/step1_indication_hp_term.txt" DGIdb_mapin_hpo_success_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/mapin_ontology/human_phenotype_ontology/step1_indication_no_hp_term.txt" DGIdb_mapin_hpo_fail_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/mapin_ontology/disease_ontology/step1_indication_do_term.txt" DGIdb_mapin_DO_success_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/mapin_ontology/disease_ontology/step1_indication_no_do_term.txt" DGIdb_mapin_DO_fail_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING/04_split_indication_target.txt" CLUE_REPURPOSING_indication_target.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING/mapin/05_no_indication_id_add_5121.txt" CLUE_REPURPOSING_used_mapin.txt
cat DGIdb_used_mapin.txt CLUE_REPURPOSING_used_mapin.txt > huan_used_mapin.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING/mapin/HPO/01_add_5121_indication_no_hp_term.txt" CLUE_REPURPOSING_mapin_hpo_fail_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING/mapin/HPO/01_add_5121_indication_hp_term.txt" CLUE_REPURPOSING_mapin_hpo_success_indication.txt
cat DGIdb_mapin_hpo_success_indication.txt CLUE_REPURPOSING_mapin_hpo_success_indication.txt > huan_mapin_hpo_success_indication.txt #把id 改为Indication_ID
cat DGIdb_mapin_hpo_fail_indication.txt CLUE_REPURPOSING_mapin_hpo_fail_indication.txt > huan_mapin_hpo_fail_indication.txt #把id 改为Indication_ID
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING/mapin/DO/01_add_5121_indication_no_do_term.txt" CLUE_REPURPOSING_mapin_do_fail_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING/mapin/DO/01_add_5121_indication_do_term.txt" CLUE_REPURPOSING_mapin_do_success_indication.txt
cat DGIdb_mapin_DO_success_indication.txt  CLUE_REPURPOSING_mapin_do_success_indication.txt > huan_mapin_do_success_indication.txt #把id 改为Indication_ID
cat DGIdb_mapin_DO_fail_indication.txt CLUE_REPURPOSING_mapin_do_fail_indication.txt > huan_mapin_do_fail_indication.txt #把id 改为Indication_ID
#人工对huan_mapin_do_success_indication.txt check得文件huan_mapin_do_success_indication1.txt
#人工对huan_mapin_hpo_success_indication.txt check得文件huan_mapin_hpo_success_indication1.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING/07_CLUE_REPURPOSING_symbol-ENSG_ID.txt" CLUE_REPURPOSING_symbol-ENSG_ID.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/dgidb_symbol-ENSG_ID.txt" DGIdb_Entrez_id-ENSG_ID.txt


cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/v84_classify2/oncodriverole/oncodrivecluster/cancer_gene_census_role.txt" cancer_gene_census_role.txt #并手动把header中的空格换成_
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/v84_classify2/oncodriverole/distinguish_out_CGC.txt" oncodriverole_gene_role.txt
perl merge_mapin1_final.pl #将mapin的hpo成功的和失败的写在一个文件里.得mapin do 的所有数据huan_mapin_do.txt。mapin hpo 的所有数据huan_mapin_hpo.txt
perl merge_mapin2.pl #将mapin do ,hpo的所有数据写在一个文件里。得文件huan_mapin.txt
 #huan_map_oncotree.txt 是huan_mapin.txt里的indication map到oncotree 的结果
perl merge_do_hpo_oncotree.pl #把huan_mapin.txt和huan_map_oncotree.txt merge到一个文件，得文件huan_mapin_do_hpo_oncotree.txt，也就是huan_mapin_do_hpo_oncotree.txt包含map到do ,hpo, oncotree的信息

#在map oncotree的时候，发现map到hpo,do时，有一些失误，所以对map hpo do进行refine
cat huan_mapin_do_hpo_oncotree.txt | cut -f1,2,3,4 >map_do_refine.txt
cat huan_mapin_do_hpo_oncotree.txt | cut -f1,2,5,6 >map_hpo_refine.txt
cat map_do_refine.txt | perl -ane 'chomp;@f= split/\t/;if($f[2]=~/NA/){print "$_\n";}' > map_do_refine_fail.txt #有1251个
cat map_do_refine.txt | perl -ane 'chomp;@f= split/\t/;unless ($f[2]=~/NA/){print "$_\n";}' > map_do_refine_succss.txt
cat map_do_refine_succss.txt | perl -ane 'chomp;@f=split/\t/;unless(/^Indication_ID/){print "$f[2]\n"}' | sort -u > uniq_map_do.txt #有1257个
cat map_hpo_refine.txt | perl -ane 'chomp;@f= split/\t/;if($f[2]=~/NA/){print "$_\n";}' > map_hpo_refine_fail.txt #有1360个
cat map_hpo_refine.txt | perl -ane 'chomp;@f= split/\t/;unless ($f[2]=~/NA/){print "$_\n";}' > map_hpo_refine_succss.txt
cat map_hpo_refine_succss.txt | perl -ane 'chomp;@f=split/\t/;unless(/^Indication_ID/){print "$f[2]\n"}' | sort -u > uniq_map_hpo.txt #有1142个

perl merge_dgidb_entrez_to_ensg_transform.pl #将DGIdb_all_target_drug_indication.txt文件中追加一列entrez对应的ensg_id,得文件
perl merge_clue_repu_symbol_ensg.pl #将CLUE_REPURPOSING_indication_target.txt文件中加入ensg_id 一列.
perl merge_CLUE_and_DGIdb.pl #将DGIdb_all_target_drug_indication_trans.txt和CLUE_REPURPOSING_indication_target_trans.txt将写在一个文件里，并在最后加一列source,得文件huan_target_drug_indication.txt
perl merge_huan_indication_ID.pl #将huan_target_drug_indication.txt的indication的ID 追加到表的最后。得文件huan_target_drug_indication_1.txt
#由于indication中有一些特殊字符，一些indication没有办法进行匹配，在huan_target_drug_indication_1.txt的基础上为这些indication手动添加id，得文件huan_target_drug_indication_final.txt
perl classfy_drug_info.pl ###将huan_target_drug_indication_final.txt没有gene symbol，但是有ensg_id的基因所在列分离开，得有symbol的文件文件huan_target_drug_indication_symbol.txt和没有symbol的文件huan_target_drug_indication_no_symbol.txt
Rscript tranform_ensg_symbol.R #将huan_target_drug_indication_no_symbol.txt的ensg转成symbol,得文件huan_transform_ensg_symbol.txt
perl merge_huan_no_symbol_ensg.pl #将文件huan_transform_ensg_symbol.txt和huan_target_drug_indication_no_symbol.txt merge起来，使huan_target_drug_indication_no_symbol.txt有symbol,并且和有symbol的文件huan_target_drug_indication_symbol.txt共同输入到一个文件
#得文件huan_target_drug_indication_final_symbol.txt

perl merge_somatic_oncodrive_cgs.pl ##将oncodriverole_gene_role.txt和cancer_gene_census_role.txt写在一个文件里。 得到文件somatic_gene_role.txt


perl merge_somatic_oncodrive_cgs.pl ###将oncodriverole_gene_role.txt和cancer_gene_census_role.txt写在一个文件里。得文件somatic_gene_role.txt
perl diff_cosmic_oncokb.pl #筛出cancer_gene_census_role.txt和oncokb_CancerGenesList.txt基因的差别.得处理后的oncokb_CancerGenesList.txt和oncokb 和cosmic中都有的具有oncorole 的基因oncokb_cosmic_gene_role.txt，只在oncokb中存在，不在cosmic中存在的具有oncorole 的基因，oncokb_single_c_gene_role.txt
perl diff_somatic_oncokb.pl #筛出somatic_gene_role.txt和oncokb_CancerGenesList.txt基因的差别.得处理后的oncokb_CancerGenesList.txt和oncokb 和cosmic中都有的具有oncorole 的基因oncokb_sosmic_gene_role.txt，只在oncokb中存在，不在cosmic中存在的具有oncorole 的基因，oncokb_single_s_gene_role.txt
cat somatic_gene_role.txt | perl -ane 'chomp; print "$_\n";' > three_source_gene_role.txt 
cat oncokb_single_c_gene_role.txt | perl -ane 'chomp;@f= split/\t/;unless(/^Gene/){print "$f[0]\tNA\tNA\t$f[1]\tOnCoKB\n"}'>> three_source_gene_role.txt
#将somatic_gene_role.txt和oncokb_single_c_gene_role.txt合为一个文件，在somatic_gene_role.txt、oncokb_single_c_gene_role.txt两个文件有五个重复基因，FLT1，BCL2L11，INPP4B，NTRK2，RAD51D。这五个基因的来源有两个，OnCoKB和oncodriverole，保留OnCoKB，删除oncodriverole来源的基因。three_source_gene_role_final.txt
Rscript trans_role_gene_symbol_ensg.R  #把three_source_gene_role_final.txt的symbol转成ensg_id,得文件three_source_gene_role_ensg.txt



perl merge_three_source_gene_role_symbol_ensg.pl #把three_source_gene_role_final.txt和three_source_gene_role_ensg.txt merge在一起，得文件three_source_gene_role_symbol_ensg.txt
perl normal_three_source_gene_role.pl #把three_source_gene_role_symbol_ensg.txt文件中的gene role都统一成LOF,和GOF,得文件normal_three_source_gene_role.txt

#因为huan_target_drug_indication_final.txt中有些基因没有gene symbol ,但这些基因有ensg_id,把这些基因所在列提出来，对其ensg_id 转换为symbol.
perl classfy_drug_info.pl #将huan_target_drug_indication_final.txt没有gene symbol，但是有ensg_id的基因所在列分离开，得到有symbol的文件huan_target_drug_indication_symbol.txt，没有symbol的文件huan_target_drug_indication_no_symbol.txt
Rscript tranform_ensg_symbol.R #将文件huan_target_drug_indication_no_symbol.txt中的ensg_id转换成symbol，得文件huan_transform_ensg_symbol.txt
perl merge_huan_no_symbol_ensg.pl #将文件huan_transform_ensg_symbol.txt和huan_target_drug_indication_no_symbol.txt merge起来，使huan_target_drug_indication_no_symbol.txt有symbol,并且和有symbol的文件huan_target_drug_indication_symbol.txt共同输入到一个文件，得huan_target_drug_indication_final_symbol.txt
perl normal_network.pl #将FIsInGene_022717_with_annotations.txt转化成random walk restart 可以用的格式。

cat huan_target_drug_indication_final_symbol.txt |perl -ane 'chomp; @f=split/\t/;print "$f[2]\t$f[4]\n" ' |sort -u >unique_drug_target_symbol_Entrez_id.txt #得到huan_target_drug_indication_final_symbol.txt的unique的gene symbol, 即得到unique的drug_target的gene symbol


#perl judge_somatic_path_gene_role.pl #用normal_three_source_gene_role.txt判断somatic_path_gene(somatic_mutation_path_ensg_entrez.txt)是GOF 还是LOF，得文件judge_somatic_path_gene_role.txt
# perl replace_gene-role_normal.pl #把judge_somatic_path_gene_role.txt中的所有的role统一成LOF和GOF,得文件 judge_somatic_path_gene_role_normal.txt
cat huan_target_drug_indication_final_symbol.txt | perl -ane 'chomp;unless(/^Drug_chembl_id/){@f=split/\t/;print "$f[6]\n";}'| sort -u >unique_drug_moa.txt
#手动将unique_drug_moa.txt精简得文件unique_manual_drug_moa.xlsx
#手动将unique_manual_drug_moa.xlsx 的第二列复制黏贴到文件unique_drug_type.txt。
perl replace.pl #对unique_drug_type.txt文件的调节因子往抑制剂和拮抗剂的方向上靠，得文件repalce.final.txt
perl classfy_drug_inhibitor_agonist.pl #把huan_target_drug_indication_final_symbol.txt中的drug分为inhibitor和agonist，得huan_target_drug_indication_final_symbol_drug-class.txt

###perl merge_cancer_gene_drug_information.pl ##把judge_somatic_path_gene_role.txt和huan_target_drug_indication_final_symbol_drug-class.txt merge成一个文件，得文件cancer_gene_drug_information.txt，得没有药物基因的somatic mutation得no_drug_somatic_path_gene_role.txt
###perl judge_cancer_gene_drug_logic.pl #判断cancer_gene_drug_information.txt中的gene role(lof和gof)与药物moa(agonist和inhibitor)的逻辑是否一致。得到逻辑一致的文件cancer_gene_drug_logic_true.txt，


perl judge_gene_based_somatic_repo_success.pl #判断merge_cancer_gene_drug_logic_true_indication_oncotree_cancer_oncotree.txt里的数据drug indication和cancer 是同一疾病。得是同一疾病的文件gene_based_somatic_repo_fail.txt
#得不是同一种疾病的文件gene_based_somatic_repo_may_success.txt,是否真的repo成功，还需要再check
cat gene_based_somatic_repo_may_success.txt | perl -ane 'chomp;unless(/^Chorm/){@f=split/\t/};unless($f[-1]=~/CUPNOS/){print "$_\n";}' > gene_based_somatic_repo_may_success_no_CUPNOS.txt

perl filter_indication_from_cancer.pl #把gene_based_somatic_repo_may_success.txt文件的在indication里出现的cancer滤掉，得文件gene_based_somatic_repo_may_success_cancer.txt

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
INDEL & SNV
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/09_somatic_snv_indel_mutationID_ensg_entrez.txt" ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/ID_project.txt" ICGC_occurthan1_snv_indel_mutationID_project.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/cancer_id_full_oncotree.txt" ICGC_occurthan1_snv_indel_project_oncotree.txt
cat ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt| perl -ane 'chomp;unless(/^Mutation_ID/){@f = split/\t/;print "$f[1]\n"}' | sort -u > unique_ICGC_occurthan1_snv_indel.txt #20216
perl 10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.pl #把ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt和ICGC_occurthan1_snv_indel_mutationID_project.txt merge在一起得文件10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.txt
perl 11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.pl #把10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.txt和ICGC_occurthan1_snv_indel_project_oncotree.txt merge在一起，得11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt
#顺便把ICGC_occurthan1_snv_indel_project_oncotree.txt normalized 把引号什么的都去掉。得ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt
perl 12_merge_ICGC_info_gene_role.pl ##把11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt和normal_three_source_gene_role.txt merge 在一起，得文件12_merge_ICGC_info_gene_role.txt
perl 13_merge_cancer_gene_drug_information.pl  #把12_merge_ICGC_info_gene_role.txt和huan_target_drug_indication_final_symbol_drug-class.txt merge 到一起，
#得文件13_ICGC_cancer_gene_drug_information.txt,得没有药物基因的somatic mutation得13_ICGC_no_drug_somatic_path_gene_role.txt,得co_gene是13_drug_cancer_co_ensg_count.txt #3039
# perl 14_judge_cancer_gene_drug_logic.pl  ##判断13_ICGC_cancer_gene_drug_information.txt中的gene role(lof和gof)与药物moa(agonist和inhibitor)的逻辑是否一致。得到逻辑一致的文件14_cancer_gene_drug_logic_true.txt，逻辑不一致的文件14_cancer_gene_drug_logic_conflict.txt，没有逻辑的文件14_no_logic_conflict.txt
# cat 14_cancer_gene_drug_logic_true.txt 14_no_logic_conflict.txt >14_cancer_gene_drug_logic_true_or_no-logic.txt   #把逻辑正确和没有逻辑的文件合在一起
perl 15_merge_cancer_gene_drug_indication_oncotree.pl ##把13_ICGC_cancer_gene_drug_information.txt和huan_mapin_do_hpo_oncotree.txt,merge在一起，得到文件15_cancer_gene_drug_indication_oncotree.txt

perl 16_judge_gene_based_somatic_repo_success.pl #判断15_cancer_gene_drug_indication_oncotree.txt里的数据drug indication和cancer 是同一疾病。得是同一疾病的文件16_gene_based_ICGC_somatic_repo_fail.txt
#得不是同一种疾病的文件16_gene_based_ICGC_somatic_repo_may_success.txt,是否真的repo成功，还需要再check
cat 16_gene_based_ICGC_somatic_repo_fail.txt | cut -f10,38 > 16_gene_based_ICGC_somatic_repo_fail_drug_disease.txt
perl 21_merge_drug_info_do_hpo_oncotree.pl #把huan_target_drug_indication_final_symbol_drug-class.txt和huan_mapin_do_hpo_oncotree.txt merge 在一起，得21_all_drug_infos.txt
perl 16.1_filter_all_drug_indication_in_icgc_project.pl  #判断15_cancer_gene_drug_indication_oncotree.txt中在ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt 中出现的drug_cancer_pair 得16.1_drug_cancer_in_icgc_project.txt #1944
cat 16.1_drug_cancer_in_icgc_project.txt | cut -f1 | sort -u > occur_orignal_drug.txt #原本就有indication 的drug 885 个
perl 17_filter_indication_from_cancer.pl #把16_gene_based_ICGC_somatic_repo_may_success.txt文件的在indication里出现的cancer滤掉，得文件有可能repo成功的repo drug pairs 文件17_drug_repo_cancer_pairs_may_success.txt #175418  得drug不可以repo的cancer文件17_drug_repo_cancer_pairs_may_fail.txt

perl 18_filter_success_pair_info.pl #把17_drug_repo_cancer_pairs_may_success.txt中的drug_repo pair从16_gene_based_ICGC_somatic_repo_may_success.txt的全部信息（整行）筛选出来。得文件18_gene_based_ICGC_somatic_repo_may_success.txt

perl 19_judge_ICGC_Indel_SNV_logic.pl #判断18_gene_based_ICGC_somatic_repo_may_success.txt是否有逻辑，为其在原文件后加logic label得19_gene_based_ICGC_somatic_repo_may_success_logic.txt得逻辑对的上的文件19_ICGC_Indel_SNV_repo-may_success_logic_true.txt 得没有逻辑的文件19_ICGC_Indel_SNV_repo-may_success_no_logic.txt,得逻辑相反的文件19_ICGC_Indel_SNV_repo-may_success_logic_conflict.txt
perl 20_filter_may_success_repo_cancer.pl #把19_ICGC_Indel_SNV_repo-may_success_logic_true.txt 的drug， repo cancer 和logic输出得20_drug_repo_cancer_logic_true.txt
cat 20_drug_repo_cancer_logic_true.txt | perl -ane 'chomp;if(/^oncotree_ID/){print "$_\n"}elsif(/^WT/){print "$_\n"}' > WT_drug.txt

perl 21_merge_drug_info_do_hpo_oncotree.pl #把huan_target_drug_indication_final_symbol_drug-class.txt和huan_mapin_do_hpo_oncotree.txt merge 在一起，得21_all_drug_infos.txt
#

cat normal_three_source_gene_role.txt | perl -ane 'chomp;unless(/^symbol|Gene/){@f= split/\t/;print "$f[0]\t$f[-1]\n";}'| sort -u > three_source_cancer_gene.txt  #2270
cat  huan_target_drug_indication_symbol.txt | cut -f1,8,9,10,11 | sort -u >unique_drug_name.txt #得用于提取drug name 的文件，手动调节header 


cat unique_drug_name1.txt | sort -u| sort -k1,1 >unique_drug_name2.txt  



perl extract_drug_gene_repo_indication.pl 把19_ICGC_Indel_SNV_repo-may_success_logic_ture.txt的drug，gene,repo,indication输出，得19_logic_ture_drug_gene_repo_indication.txt