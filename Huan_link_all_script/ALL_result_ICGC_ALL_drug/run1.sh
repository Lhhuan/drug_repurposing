cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/step10-3_all_target_drug_indication.txt" DGIdb_all_target_drug_indication.txt
perl refine_DGIdb_all_target_drug_indication1.pl #因为DGIdb_all_target_drug_indication.txt中把来源于DrugBank中的drug indication 统计了两遍，这里要对出现两次的进行去重。这步先把indication 来源于DrugBank和非 drugbank 分开。
#分别得来源是DGIdb_all_target_drug_indication_drugbank.txt和DGIdb_all_target_drug_indication_no_drugbank.txt
#并将DGIdb_all_target_drug_indication_drugbank.txt中indication_source是NA和不是NA的分开输出，得DGIdb_all_target_drug_indication_drugbank_source_NA.txt DGIdb_all_target_drug_indication_drugbank_source_not_NA.txt
#将上两个文件去重，相同的留下有link的数据，最后的文件DGIdb_all_target_drug_indication_drugbank_final.txt ，并得除link那列，drugbank的所有unique数据，用于评价DGIdb_all_target_drug_indication_drugbank_final.txt是否正确。
#DGIdb_all_target_drug_indication_drugbank_final.txt只比DGIdb_all_target_drug_indication_drugbank_unique.txt多一行header，去重正确。
cat DGIdb_all_target_drug_indication_no_drugbank.txt DGIdb_all_target_drug_indication_drugbank_final.txt >DGIdb_all_target_drug_indication_refine.txt
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
cp huan_mapin_do_hpo_oncotree.txt huan_mapin_do_hpo_oncotree_main.txt 
#把huan_mapin_do_hpo_oncotree.txt map到oncotree 的主干组织上，得huan_mapin_do_hpo_oncotree_main1.txt
#----------------------------------------------------------------------------------------------------
#因为之前drugbank中uniprot_id转ENSGID时漏掉了一部分，其他部分只需重跑代码就好了，但是indication部分多了一部分数据，需要对其编号并对DO,HPO,oncotree进行mapin 
    perl find_indication_new.pl   #找出在DGIdb_all_target_drug_indication.txt中存在，但在huan_used_mapin.txt中不存在的indication,（也就是新增的indication）,得new_add_drugbank_indication.txt,得huan_used_mapin.txt 把引号去掉，全部转变成小写后的结果refine_huan_used_mapin.txt，
    #手动检查 new_add_drugbank_indication.txt中因为字符问题不能匹配的indication ,并添加ID最后得refine_new_add_drugbank_indication.txt,
    perl extract_before_unique_indication.pl #用refine_huan_used_mapin.txt到huan_used_mapin.txt中提取unique的indication ID及indication，得refine_huan_used_mapin_id.txt,由于字符问题不能匹配的indication character_error_indication.txt    
    perl extract_before_unique_indication_mapin.pl #利用refine_huan_used_mapin_id.txt 在huan_mapin_do_hpo_oncotree_main1.txt提取unique 的mapin 结果，最终得到huan_mapin_do_hpo_oncotree_before.txt
    #在add_new_indication_map_DO_HPO_Oncotree中处理漏掉的indication，
    cat refine_huan_used_mapin_id.txt ./add_new_indication_map_DO_HPO_Oncotree/refine_new_add_drugbank_indication_s.txt > huan_used_mapin_final.txt
    cat huan_mapin_do_hpo_oncotree_before.txt ./add_new_indication_map_DO_HPO_Oncotree/merge_add_hpo_do_oncotree_s.txt >huan_mapin_do_hpo_oncotree_all.txt
    #对huan_mapin_do_hpo_oncotree_all.txt进行检查，得huan_mapin_do_hpo_oncotree_final.txt
#------------------------------------------------

perl merge_dgidb_entrez_to_ensg_transform.pl #用DGIdb_Entrez_id-ENSG_ID.txt将DGIdb_all_target_drug_indication_refine.txt (原来是DGIdb_all_target_drug_indication.txt)文件中追加一列entrez对应的ensg_id,得文件DGIdb_all_target_drug_indication_trans.txt
perl merge_clue_repu_symbol_ensg.pl #将CLUE_REPURPOSING_indication_target.txt文件中加入ensg_id 一列.
perl merge_CLUE_and_DGIdb.pl #将DGIdb_all_target_drug_indication_trans.txt和CLUE_REPURPOSING_indication_target_trans.txt将写在一个文件里，并在最后加一列source,得文件huan_target_drug_indication.txt
perl merge_huan_indication_ID.pl #用huan_used_mapin_final.txt将huan_target_drug_indication.txt的indication的ID 追加到表的最后。得文件huan_target_drug_indication_1.txt
#由于indication中有一些特殊字符，一些indication没有办法进行匹配，在huan_target_drug_indication_1.txt的基础上为这些indication手动添加id，得文件huan_target_drug_indication_final.txt
#------------------------------------------------------------------------------
    cat huan_target_drug_indication_1.txt | perl -ane 'chomp;@f=split/\t/;if($f[-1]=~/NA/){print "$_\n";}' >huan_target_drug_indication_na.txt  #因为特殊字符，手动将huan_target_drug_indication_na.txt的NA 替换为ID,得huan_target_drug_indication_na1.txt
    cat huan_target_drug_indication_1.txt | perl -ane 'chomp;@f=split/\t/;unless($f[-1]=~/NA/){print "$_\n";}' >huan_target_drug_indication_not_na.txt
    cat huan_target_drug_indication_not_na.txt huan_target_drug_indication_na1.txt >huan_target_drug_indication_final.txt
#------------------------------------------------------------------------------

#因为huan_target_drug_indication_final.txt中有些基因没有gene symbol ,但这些基因有ensg_id,把这些基因所在列提出来，对其ensg_id 转换为symbol.
perl classfy_drug_info.pl ###将huan_target_drug_indication_final.txt没有gene symbol，但是有ensg_id的基因所在列分离开，得有symbol的文件文件huan_target_drug_indication_symbol.txt和没有symbol的文件huan_target_drug_indication_no_symbol.txt
Rscript tranform_ensg_symbol.R #将huan_target_drug_indication_no_symbol.txt的ensg转成symbol,得文件huan_transform_ensg_symbol.txt
perl merge_huan_no_symbol_ensg.pl #将文件huan_transform_ensg_symbol.txt和huan_target_drug_indication_no_symbol.txt merge起来，使huan_target_drug_indication_no_symbol.txt有symbol,并且和有symbol的文件huan_target_drug_indication_symbol.txt共同输入到一个文件
#得文件huan_target_drug_indication_final_symbol.txt
#---------------------------------------------------------------------
perl refine_huan_target_drug_indication_final_symbol.pl ##huan_target_drug_indication_final_symbol.txt中同一药物对于同一基因的MOA,有的数据库(如drugbank)记录NA，有的数据库(如TTD)记录inhibitor,
#所以从此处开始，不再记录Interaction_claim_source的来源，只记录总来源DGIdb,也不再记录Gene_claim_name等信息（Gene_claim_name、Drug_chembl_id|Drug_claim_name、Drug_claim_name,drug_name这可以反映Interaction_claim_source的来源）所以这个也要删掉，像刚刚的情况，则记录药物对某基因的moa(Interaction_types)为inhibitor，得文件DGIdb_all_target_drug_indication_refine_final.txt
#得moa 为na类的药物huan_target_drug_indication_final_symbol_moa_na.txt，moa不为na类的药物文件huan_target_drug_indication_final_symbol_moa_not_na.txt，最后得moa去重后的文件huan_target_drug_indication_final_symbol_refine.txt
#######以前用huan_target_drug_indication_final_symbol.txt处理的文件，下面用huan_target_drug_indication_final_symbol_refine.txt处理。


#-------------------------------------------------------------------------------------------------------------------------- cancer gene role
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
#------------------------------------------------------------------------------------------------------------------------
# #因为huan_target_drug_indication_final.txt中有些基因没有gene symbol ,但这些基因有ensg_id,把这些基因所在列提出来，对其ensg_id 转换为symbol.
# perl classfy_drug_info.pl #将huan_target_drug_indication_final.txt没有gene symbol，但是有ensg_id的基因所在列分离开，得到有symbol的文件huan_target_drug_indication_symbol.txt，没有symbol的文件huan_target_drug_indication_no_symbol.txt
# Rscript tranform_ensg_symbol.R #将文件huan_target_drug_indication_no_symbol.txt中的ensg_id转换成symbol，得文件huan_transform_ensg_symbol.txt
# perl merge_huan_no_symbol_ensg.pl #将文件huan_transform_ensg_symbol.txt和huan_target_drug_indication_no_symbol.txt merge起来，使huan_target_drug_indication_no_symbol.txt有symbol,并且和有symbol的文件huan_target_drug_indication_symbol.txt共同输入到一个文件，得huan_target_drug_indication_final_symbol.txt
#---------------------------------------------------------------------------
perl normal_network.pl #将FIsInGene_022717_with_annotations.txt转化成random walk restart 可以用的格式。
#-------------------------------------------------------------------------------------------
#cat huan_target_drug_indication_final_symbol.txt |perl -ane 'chomp; @f=split/\t/;print "$f[2]\t$f[4]\n" ' |sort -u >unique_drug_target_symbol_Entrez_id.txt #得到huan_target_drug_indication_final_symbol.txt的unique的gene symbol, 即得到unique的drug_target的gene symbol


#perl judge_somatic_path_gene_role.pl #用normal_three_source_gene_role.txt判断somatic_path_gene(somatic_mutation_path_ensg_entrez.txt)是GOF 还是LOF，得文件judge_somatic_path_gene_role.txt
# perl replace_gene-role_normal.pl #把judge_somatic_path_gene_role.txt中的所有的role统一成LOF和GOF,得文件 judge_somatic_path_gene_role_normal.txt
#cat huan_target_drug_indication_final_symbol.txt | perl -ane 'chomp;unless(/^Drug_chembl_id/){@f=split/\t/;print "$f[5]\n";}'| sort -u >unique_drug_moa.txt
#手动将unique_drug_moa.txt精简得文件unique_manual_drug_moa.xlsx
#手动将unique_manual_drug_moa.xlsx 的第二列复制黏贴到文件unique_drug_type.txt。
perl replace.pl #对unique_drug_type.txt文件的调节因子往抑制剂和拮抗剂的方向上靠，得文件repalce.final.txt
perl classfy_drug_inhibitor_agonist.pl #把huan_target_drug_indication_final_symbol_refine.txt中的drug分为inhibitor和agonist，得huan_target_drug_indication_final_symbol_drug-class.txt
perl filter_repeat_Drug_chembl_id_Drug_claim_primary_name.pl #因为dgidb中的药物收集来源于多个数据库，所以huan_target_drug_indication_final_symbol_drug-class.txt中有的同一Drug_claim_primary_name的chembl 有的是NA,有的是chembl ID，
#这样同一个药物就对应两个Drug_claim_primary_name_Drug_chembl_id,所以在这里进行去重，留下有chembl id的Drug_claim_primary_name_Drug_chembl_id，得unique_Drug_claim_primary_name_Drug_chembl_id.txt
perl extract_Drug_claim_primary_name_Drug_chembl_id_info.pl #用unique_Drug_claim_primary_name_Drug_chembl_id.txt 中Drug_claim_primary_name从huan_target_drug_indication_final_symbol_drug-class.txt提取其他的信息
#得refined_huan_target_drug_indication_final_symbol.txt ，

#####从此处开始，原本用huan_target_drug_indication_final_symbol_drug-class.txt处理的脚本，都改用refined_huan_target_drug_indication_final_symbol.txt处理。

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
INDEL & SNV
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/09_somatic_snv_indel_mutationID_ensg_entrez.txt" ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/ID_project.txt" ICGC_occurthan1_snv_indel_mutationID_project.txt  #这个是mutation occur >1的cancer。
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/cancer_id_full_oncotree1.txt" ICGC_occurthan1_snv_indel_project_oncotree.txt
cat ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt| perl -ane 'chomp;unless(/^Mutation_ID/){@f = split/\t/;print "$f[1]\n"}' | sort -u > unique_ICGC_occurthan1_snv_indel.txt #20216
perl 10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.pl #把ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt和ICGC_occurthan1_snv_indel_mutationID_project.txt merge在一起得文件10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.txt
perl 11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.pl #把10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.txt和ICGC_occurthan1_snv_indel_project_oncotree.txt merge在一起，得11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt
#顺便把ICGC_occurthan1_snv_indel_project_oncotree.txt normalized 把引号什么的都去掉。得ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt
perl 12_merge_ICGC_info_gene_role.pl ##把11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt和normal_three_source_gene_role.txt merge 在一起，得文件12_merge_ICGC_info_gene_role.txt
perl 13_merge_cancer_gene_drug_information.pl  #把12_merge_ICGC_info_gene_role.txt和refined_huan_target_drug_indication_final_symbol.txt merge 到一起，
#得文件13_ICGC_cancer_gene_drug_information.txt,得没有药物基因的somatic mutation得13_ICGC_no_drug_somatic_path_gene_role.txt,得co_gene是drug_cancer_co_ensg_count.txt
perl 15_merge_cancer_gene_drug_indication_oncotree.pl ##把13_ICGC_cancer_gene_drug_information.txt和huan_mapin_do_hpo_oncotree_final.txt,merge在一起，得到文件15_cancer_gene_drug_indication_oncotree.txt
perl 21_merge_drug_info_do_hpo_oncotree.pl #把refined_huan_target_drug_indication_final_symbol.txt和huan_mapin_do_hpo_oncotree_final.txt merge 在一起，得21_all_drug_infos.txt
perl find_original_drug_cancer_pair.pl #把21_all_drug_infos.txt中原本治疗cancer 的drug筛选出来，得original_drug_cancer_pair.txt，共
            #-----------------------------------------------------这里本来是判断药物indication和cancer是否一样，现在判断太早了，所以这些先跳过，把这些脚本和数据都先放进/f/mulinlab/huan/All_result_ICGC/judge_cancer_indication_same/
                            # perl 16_judge_gene_based_somatic_repo_success.pl #判断15_cancer_gene_drug_indication_oncotree.txt里的数据drug indication和cancer 是同一疾病。得是同一疾病的文件16_gene_based_ICGC_somatic_repo_fail.txt
                            # #得不是同一种疾病的文件16_gene_based_ICGC_somatic_repo_may_success.txt,是否真的repo成功，还需要再check
                            # perl 16.1_filter_all_drug_indication_in_icgc_project.pl  #判断15_cancer_gene_drug_indication_oncotree.txt中在ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt 中出现的drug_cancer_pair 得16.1_drug_cancer_in_icgc_project.txt #1944
                            # cat 16.1_drug_cancer_in_icgc_project.txt | cut -f1 | sort -u > occur_orignal_drug.txt #原本就有indication 的drug 885 个
                            # perl 17_filter_indication_from_cancer.pl #把16_gene_based_ICGC_somatic_repo_may_success.txt文件的在indication里出现的cancer滤掉，得文件有可能repo成功的repo drug pairs 文件17_drug_repo_cancer_pairs_may_success.txt #175418  得drug不可以repo的cancer文件17_drug_repo_cancer_pairs_may_fail.txt

                            # perl 18_filter_success_pair_info.pl #把17_drug_repo_cancer_pairs_may_success.txt中的drug_repo pair从16_gene_based_ICGC_somatic_repo_may_success.txt的全部信息（整行）筛选出来。得文件18_gene_based_ICGC_somatic_repo_may_success.txt
            #-------------------------------------------------------------
perl 19_judge_ICGC_Indel_SNV_logic.pl #判断15_cancer_gene_drug_indication_oncotree.txt是否有逻辑，为其在原文件后加logic label得19_gene_based_ICGC_somatic_repo_may_success_logic.txt得逻辑对的上的文件19_ICGC_Indel_SNV_repo-may_success_logic_true.txt 得没有逻辑的文件19_ICGC_Indel_SNV_repo-may_success_no_logic.txt,得逻辑相反的文件19_ICGC_Indel_SNV_repo-may_success_logic_conflict.txt

#--------------------------------------------------------------------------------------------------------------------------------

perl 20_filter_may_success_repo_cancer.pl #把19_ICGC_Indel_SNV_repo-may_success_logic_true.txt 的drug， repo cancer 和logic输出得20_drug_repo_cancer_logic_true.txt
perl extract_drug_gene_repo_indication.pl #把19_ICGC_Indel_SNV_repo-may_success_logic_ture.txt的drug，gene,repo,indication输出，得19_logic_ture_drug_gene_repo_indication.txt

cat normal_three_source_gene_role.txt | perl -ane 'chomp;unless(/^symbol|Gene/){@f= split/\t/;print "$f[0]\t$f[-1]\n";}'| sort -u > three_source_cancer_gene.txt  #2270
#cat  huan_target_drug_indication_symbol.txt | cut -f1,8,9,10,11 | sort -u >unique_drug_name.txt #得用于提取drug name 的文件，手动调节header   #这个给翟思南，用于在DGIdb网页上抓取drug target score
#此处应该用huan_target_drug_indication_final_symbol.txt 提取drug name 
#-------------------------------------------------------
               perl find_new_drugs.pl #检查把drugbank 药物更新后，相比于之前多的数据。即用huan_target_drug_indication_final_symbol.txt检查比check_DGIDB_drug_target_score.txt多出的药物。得new_drug_need_find_score.txt
                new_drug_need_find_score.txt 需要思南和吴承蔚来抓
#-------------------------------------------------------

#给unique_drug_name.txt加header得，unique_drug_name1.txt.(这里的huan_target_drug_indication_symbol.txt使用的修复前的脚本)
#----------------------------------------------------------------------------------------------------------
cat unique_drug_name1.txt new_drug_need_find_score.txt > use_to_find_score.txt


cp /f/mulinlab/sinan/drug_target_score_v3.txt  ./DGIDB_drug_target_score1.txt #此文件为翟思南和吴承蔚从DGIDB手动扣下来的drug target score #此文件是用unique_drug_name.txt抓出来的。
#从翟思南哪里copy的文件有错误，由DGIDB_drug_target_score1.txt 修正得DGIDB_drug_target_score.txt
cp /f/mulinlab/sinan/new_drug_need_find_score_all.txt ./DGIDB_drug_target_score2.txt #用new_drug_need_find_score.txt抓出来的数据。
cat DGIDB_drug_target_score.txt DGIDB_drug_target_score2.txt > DGIDB_drug_target_score_final.txt #
perl normal_DGIDB_drug_target_score.pl  #把DGIDB_drug_target_score_final.txt的name 进行normal ,(因为之前给sinan的文件中 repurpose hub没有严格按照有chembl的chembl填充，现在之前的文件已经修改好，
#所以这里要dui sinan 给的文件进行统一化，有chembl按照chembl填充，没有chembl的按照drug name填充,这里需要借助unique_drug_name1.txt )，得normal_DGIDB_drug_target_score.txt
#Rscript tranfrom_dgidb_target_score_symbol_ensgid_entrezid.R #把normal_DGIDB_drug_target_score.txt的symbol转为ensgid和entrezid，得tranfrom_dgidb_target_score_symbol_ensgid_entrezid.txt

perl merge_huan_drug_target_score.pl #将21_all_drug_infos.txt和normal_DGIDB_drug_target_score.txt中的target score merge到一起，得all_drug_infos_score.txt
perl extract_drug_target_score.pl #把all_drug_infos_score.txt 中的Drug_claim_primary_name,Entrez_id,Drug_type, drug_target_score，并把drugname 转成小写，这一步的数据是为用金标准对ranking system 做验证用，得brief_drug_target_info.txt

#-----------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------为画图做准备
perl find_drug_type.pl #为all_drug_infos_score.txt 中的drug 在"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/getfromdrugbank2017-12-18.txt" #找type,比如：biotech，small_molecule等
#得all_drug_infos_score_type.txt
perl classfy_drug_by_cancer_or_not.pl #把cancer drug和非cancer drug 分开，得cancer drug文件cancer_drug_type.txt, 得非cancer drug文件，noncancer_drug_type.txt
#记录cancer 和非cancer drug每种drug type的cancer数目，分别得文件cancer_drug_type_number.txt， noncancer_drug_type_number.txt #共有cancer drug 1603个，非cancer drug 4345个

perl find_drug_unique_status.pl #all_drug_infos_score.txt 中的drug 因为有多个indication，所有会显示有多个status, 为drug找出最大的status 确定为drug 的status，得all_drug_unique_status_media.txt ,
#将all_drug_unique_status_media.txt中First_approval有年份的写fda approved
perl merge_drug_unique_status_cancer.pl #将all_drug_unique_status.txt 和cancer_drug_type.txt， noncancer_drug_type.txt merge 到一起，得cancer drug 的status 文件cancer_drug_type_status.txt
#得non-cancer 的status 文件 non-cancer_drug_type_status.txt.
#记录cancer 和非cancer drug每种drug type的cancer数目，分别得文件cancer_drug_status_number.txt， noncancer_drug_status_number.txt