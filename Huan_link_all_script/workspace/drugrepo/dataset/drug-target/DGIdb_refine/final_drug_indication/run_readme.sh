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

#-----------------------------------------------------------------------------------------------
#---------------------处理原则：首先把drug indication合并，用chembl、drug claim name、drug claim primary name分别提取drug indication及indication class 
#因为TTD-drug_indication.txt是在TTD_indication.txt中提取的，TdgClinicalTrial-drug_indication.txt从TdgClinicalTrial_source_indication.txt中提取的，
#TEND_drug_indication.txt是从TEND.txt中提取的，chembl1-drug_indication.txt从chembl_indications-17_13-38-29.txt中提取的，chembl2-drug_indication.txt从chembl_indication.txt中提取的。
#所以需要合并的所有文件为：Drugbank_drug_indication.txt、GuideToPharmacology-drug_indication.txt、chembl_indication.txt、chembl_molecules.txt、chembl_indications-17_13-38-29.txt
#TTD_indication.txt、clinical.trial-drug-indication.txt、TdgClinicalTrial_source_indication.txt、TEND.txt、drugcentral_drug_indication.txt
#------------------------------------------------------------------------
perl 01_merge_all_drug_indications.pl #将Drugbank_drug_indication.txt、GuideToPharmacology-drug_indication.txt、chembl_indication.txt、chembl_molecules.txt、chembl_indications-17_13-38-29.txt
#TTD_indication.txt、clinical.trial-drug-indication.txt、TdgClinicalTrial_source_indication.txt、TEND.txt、drugcentral_drug_indication.txt 合并得01_merge_all_drug_indications.txt