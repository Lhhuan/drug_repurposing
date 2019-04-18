#用drug claim name 提取。
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/step4_drugbank_drug_gene_entrez_id.txt" ./output/Drugbank_drug_indication.txt #有drug type信息
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/TTD-indication/step2_result_TTD-gene-indication.txt" ./output/TTD-drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/GuideToPharmacologyInteractions/step2_result_drug_indication.txt" ./output/GuideToPharmacology-drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/TdgClinicalTrial/step2_result_drug_indication.txt" ./output/TdgClinicalTrial-drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/TEND/step2_result_drug_indication.txt"  ./output/TEND_drug_indication.txt 
#----------------------------------------------chembl 提取
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/Chembl-indication/step2-result.txt" ./output/chembl1-drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/Chembl-indication/step4-result.txt" ./output/chembl2-drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/Chembl-indication/step3_result.txt" ./output/chembl_indication.txt
#从postgresql恢复得文件drugs.txt，drug_claims.txt，chembl_molecules.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/uni-drug-2/chembl_molecules.txt" ./output/chembl_molecules.txt #from dgidb #这个里面提供的是drug indication class
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/Chembl-indication/chembl_indications-17_13-38-29.txt"  ./output/chembl_indications-17_13-38-29.txt #有drug type信息
# cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/Chembl-indication/assays.txt" chembl_assay.txt #这个是对细胞水平的描述。所以这个不用于寻找indication了。
#---drug claim primary name提取
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/TTD-old/Result_TTDdrugid_drugname_disease.txt" ./output/TTD_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/clinical.trial/result_NCDid_title_phase_drug_disease_diseaseterm" ./output/clinical.trial-drug-indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/TdgClinicalTrial/pa54_rask-andersen_suptable1-LING.txt" ./output/TdgClinicalTrial_source_indication.txt #有drug type信息。
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/TEND/nrd3478-s1-TEND.txt" ./output/TEND.txt #有Target main class 信息
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/drugCentral/struct_id-drug_active_name-drug_substance_name_disease_concept_name-disease_full_name" ./output/drugcentral_drug_indication.txt
#cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/step4_drugbank_drug_gene_entrez_id.txt" Drugbank_drug_indication.txt

#-----------------manmual
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------
#---------------------处理原则：首先把drug indication合并，用chembl、drug claim name、drug claim primary name分别提取drug indication及indication class 
#因为TTD-drug_indication.txt是在TTD_indication.txt中提取的，TdgClinicalTrial-drug_indication.txt从TdgClinicalTrial_source_indication.txt中提取的，
#TEND_drug_indication.txt是从TEND.txt中提取的，chembl1-drug_indication.txt从chembl_indications-17_13-38-29.txt中提取的，chembl2-drug_indication.txt从chembl_indication.txt中提取的。
#所以需要合并的所有文件为：Drugbank_drug_indication.txt、GuideToPharmacology-drug_indication.txt、chembl_indication.txt、chembl_molecules.txt、chembl_indications-17_13-38-29.txt
#TTD_indication.txt、clinical.trial-drug-indication.txt、TdgClinicalTrial_source_indication.txt、TEND.txt、drugcentral_drug_indication.txt
#------------------------------------------------------------------------
perl 01_merge_all_drug_indications.pl #将Drugbank_drug_indication.txt、GuideToPharmacology-drug_indication.txt、chembl_indication.txt、chembl_molecules.txt、chembl_indications-17_13-38-29.txt
#TTD_indication.txt、clinical.trial-drug-indication.txt、TdgClinicalTrial_source_indication.txt、TEND.txt、drugcentral_drug_indication.txt 合并得./output/01_merge_all_drug_indications.txt
#------下面的drug_stage 是无效的，为了和后面脚本衔接，此处保留drug_stage
perl 02_merge_dgidb_and_drugbank.pl #将./output/interactions_v3.tsv 和./output/Drugbank_drug_indication.txt merge 到一起，得./output/02_dgidb_all_drug_target.txt
perl 03_add_CheMBL_drug_claim_primary_name.pl #在./output/02_dgidb_all_drug_target.txt 的基础上加了drug_chembl_id|drug_claim_primary_name这一列，用drug_chembl_id和drug_claim_primary_name这两个属性进行筛选。有drug_chembl_id的用drug_chembl_id，没有的用drug_claim_primary_name 
#得./output/03_dgidb_all_drug_target.txt
perl 04_find_indication_for_drugs.pl #用./output/01_merge_all_drug_indications.txt为./output/03_dgidb_all_drug_target.txt中的药物寻找indication，得全部的药物 indication 状态：./output/04_all_drug_indciation.txt
#得有适应症的药物./output/04_drug_known_indication.txt，得没有适应症的药物./output/04_drug_unknown_indication.txt
perl 05_add_indication_class.pl #在./output/04_all_drug_indciation.txt中Drug_indication这一列中没有值的，输出Indication_class，生成一列新数据Drug_indication|Indication_class，得./output/05_all_drug_indciation.txt
cat ./output/05_all_drug_indciation.txt | perl -ane 'unless(/^Drug_chembl_id/){chomp;my @f = split/\t/;print "$f[5]\n";}' |sort -u > ./output/uni_Entrez_id.txt
Rscript 06_transform_entrez_to_ensg.R #把./output/uni_Entrez_id.txt中的 Entrez 转成ENSG，得./output/transform.txt
perl 07_deal_tranfrom_gene.pl #对./output/transform.txt的一些字符进行一些处理，得文件./output/dgidb_entrez-ENSG_ID.txt