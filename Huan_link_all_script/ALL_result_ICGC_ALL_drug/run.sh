#-------------------------------------------------------------------------------------------before indication do hpo oncotree
cat "/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" | head -1 |cut -f14,19,20,21,22,23,24,25,26 >./output/before_indication_do_hpo_oncotree.txt
cat "/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" | awk 'NR>1' |cut -f14,19,20,21,22,23,24,25,26|sort -u >>./output/before_indication_do_hpo_oncotree.txt

#----------------------------------------------------------------------------------------------------drug target and drug indication
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/final_drug_indication/output/05_all_drug_indciation.txt" ./output/DGIdb_all_target_drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/final_drug_indication/output/dgidb_entrez-ENSG_ID.txt" ./output/DGIdb_Entrez_id-ENSG_ID.txt

perl 01_merge_dgidb_entrez_to_ensg_transform.pl #用./output/DGIdb_Entrez_id-ENSG_ID.txt将./output/DGIdb_all_target_drug_indication.txt文件中追加一列entrez对应的ensg_id,得文件./output/DGIdb_all_target_drug_indication_trans.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING/04_split_indication_target.txt" ./output/CLUE_REPURPOSING_indication_target.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING/07_CLUE_REPURPOSING_symbol-ENSG_ID.txt" ./output/CLUE_REPURPOSING_symbol-ENSG_ID.txt
perl 02_merge_clue_repu_symbol_ensg.pl #利用./output/CLUE_REPURPOSING_indication_target.txt为./output/CLUE_REPURPOSING_symbol-ENSG_ID.txt文件中加入ensg_id 一列，得./output/CLUE_REPURPOSING_indication_target_trans.txt
perl 03_merge_CLUE_and_DGIdb.pl #将./output/DGIdb_all_target_drug_indication_trans.txt和./output/CLUE_REPURPOSING_indication_target_trans.txt将写在一个文件里，并在最后加一列source,得./output/huan_target_drug_indication.txt
perl 04_find_new_add_indication.pl # # 找出在./output/before_indication_do_hpo_oncotree.txt中存在但在./output/huan_target_drug_indication.txt 中不存在的indication,得文件./output/04_new_indication.txt
#在./output/before_indication_do_hpo_oncotree.txt中存在，在./output/huan_target_drug_indication.txt 中也存在的indication也存在的indication及oncotree map等得文件./output/04_indication_in_before_do_hpo_oncotree.txt,
#得在./output/before_indication_do_hpo_oncotree.txt中存在，在./output/huan_target_drug_indication.txt不存在的indication 文件是./output/04_before_indication_not_in_now_indication.txt
#对./output/04_indication_in_before_do_hpo_oncotree.txt进行check,得./output/04_indication_in_before_do_hpo_oncotree_final.txt
perl 05_add_unmap_do_hpo.pl #因为./output/04_new_indication.txt中indication 较多，有5615个，map 到hpo和do浪费时间较多，但此map并无意义，所以此处用unmap代替。得文件./output/05_new_indication_do_hpo_unmap.txt
#同时在./output/05_new_indication_do_hpo_unmap.txt基础上，将indication映射到oncotree，得文件./output/05_new_indication_do_hpo_oncotree.txt
cat ./output/05_new_indication_do_hpo_oncotree.txt ./output/04_indication_in_before_do_hpo_oncotree_final.txt > ./output/all_indication_do_hpo_oncotree.txt
perl 06_add_indication_ID.pl #为./output/all_indication_do_hpo_oncotree.txt中的indication编号，得./output/all_id_indication_do_hpo_oncotree.txt
perl 07_merge_id_for_all_indication.pl  #用./output/all_id_indication_do_hpo_oncotree.txt为./output/huan_target_drug_indication.txt添加indication id，得./output/07_huan_target_drug_indication.txt
#由于indication中有一些特殊字符，一些indication没有办法进行匹配，在./output/07_huan_target_drug_indication.txt的基础上为这些indication手动添加id，得文件./output/07_huan_target_drug_indication_final.txt
    cat ./output/07_huan_target_drug_indication.txt | perl -ane 'chomp;@f=split/\t/;unless($f[-1]=~/NA/){print "$_\n";}' >./output/07_huan_target_drug_indication_not_na.txt
    cat ./output/07_huan_target_drug_indication.txt | perl -ane 'chomp;@f=split/\t/;if($f[-1]=~/NA/){print "$_\n";}' >./output/07_huan_target_drug_indication_na.txt
    #因为特殊字符，手动将./output/07_huan_target_drug_indication_na.txt的NA 替换为ID,得./output/07_huan_target_drug_indication_na1.txt
    cat ./output/07_huan_target_drug_indication_not_na.txt ./output/07_huan_target_drug_indication_na1.txt >./output/07_huan_target_drug_indication_final.txt 
#---------------------------------------------------------------------------------------------------------

#因为./output/07_huan_target_drug_indication_final.txt中有些基因没有gene symbol ,但这些基因有ensg_id,把这些基因所在列提出来，对其ensg_id 转换为symbol.
perl 08_classfy_drug_info.pl ###将./output/07_huan_target_drug_indication_final.txt没有gene symbol，但是有ensg_id的基因所在行分离开，得有symbol的文件文件./output/08_huan_target_drug_indication_symbol.txt
#和没有symbol的文件./output/08_huan_target_drug_indication_no_symbol.txt
Rscript 09_tranform_ensg_symbol.R #将./output/08_huan_target_drug_indication_no_symbol.txt的ensg转成symbol,得文件./output/09_huan_transform_ensg_symbol.txt
perl 10_merge_huan_no_symbol_ensg.pl #将文件./output/09_huan_transform_ensg_symbol.txt和./output/08_huan_target_drug_indication_no_symbol.txt merge起来，
#使./output/08_huan_target_drug_indication_no_symbol.txt有symbol,并且和有symbol的文件./output/08_huan_target_drug_indication_symbol.txt共同输入到一个文件
#得文件./output/10_huan_target_drug_indication_final_symbol.txt
#---------------------------------
#----------------------------------------------
perl 11_refine_huan_target_drug_indication_final_symbol.pl ##./output/10_huan_target_drug_indication_final_symbol.txt中同一药物对于同一基因的MOA,有的数据库(如drugbank)记录NA，有的数据库(如TTD)记录inhibitor,
#所以从此处开始，不再记录Interaction_claim_source的来源，只记录总来源DGIdb,也不再记录Gene_claim_name等信息（Gene_claim_name、Drug_chembl_id|Drug_claim_name、Drug_claim_name,drug_name这可以反映Interaction_claim_source的来源）所以这个也要删掉，
#像刚刚的情况，则记录药物对某基因的moa(Interaction_types)为inhibitor，得文件./output/11_DGIdb_all_target_drug_indication_refine_final.txt
#得moa为na类的药物./output/11_huan_target_drug_indication_final_symbol_moa_na.txt，moa不为na类的药物文件./output/11_huan_target_drug_indication_final_symbol_moa_not_na.txt，
#最后得moa去重后的文件./output/11_huan_target_drug_indication_final_symbol_refine.txt

#-----------------------------------------
#-------------------------------------------------------------------------------------------------------------------------- cancer gene role
cp "/f/mulinlab/huan/All_result_ICGC/normal_three_source_gene_role.txt" ./output/normal_three_source_gene_role.txt

#------------------------------------------------------------------------------------------------------------------------ normal network
perl normal_network.pl #将./output/FIsInGene_022717_with_annotations.txt转化成random walk restart 可以用的格式，得文件./output/normal_network.txt。

#-----------------------------------------------------------------------------------------------------------------------------summary drug information
perl classfy_drug_inhibitor_agonist.pl #把./output/11_huan_target_drug_indication_final_symbol_refine.txt中的drug分为inhibitor和agonist，得./output/huan_target_drug_indication_final_symbol_drug-class.txt

perl filter_repeat_Drug_chembl_id_Drug_claim_primary_name.pl #因为dgidb中的药物收集来源于多个数据库，所以./output/huan_target_drug_indication_final_symbol_drug-class.txt中有的同一Drug_claim_primary_name的chembl 有的是NA,有的是chembl ID，
#这样同一个药物就对应两个Drug_claim_primary_name_Drug_chembl_id,所以在这里进行去重，留下有chembl id的Drug_claim_primary_name_Drug_chembl_id，得./output/unique_Drug_claim_primary_name_Drug_chembl_id.txt
perl extract_Drug_claim_primary_name_Drug_chembl_id_info.pl #用./output/unique_Drug_claim_primary_name_Drug_chembl_id.txt 中Drug_claim_primary_name从./output/huan_target_drug_indication_final_symbol_drug-class.txt提取其他的信息
#得./output/refined_huan_target_drug_indication_final_symbol.txt  #为了避免同一种Drug_chembl_id_Drug_claim_primary_name 有两个名字A-B和AB而造成的重复，此处对Drug_chembl_id_Drug_claim_primary_name进行处理。
