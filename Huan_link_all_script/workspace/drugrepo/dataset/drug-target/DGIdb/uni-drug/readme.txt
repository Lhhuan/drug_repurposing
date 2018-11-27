复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/step2_result_gene_drug.txt"得Drugbank_drug_indication.txt.
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/TTD-indication/step2_result_TTD-gene-indication"得TTD-drug_indication.txt
复制 "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/GuideToPharmacologyInteractions/step2_result_drug_indication" 得GuideToPharmacology-drug_indication.txt
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/Chembl-indication/step2-result.txt"得chembl1-drug_indication.txt
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/Chembl-indication/step4-result.txt"得文件chembl2-drug_indication.txt
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/TdgClinicalTrial/step2_result_drug_indication" 得文件TdgClinicalTrial-drug_indication.txt
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/TEND/step2_result_drug_indication.txt" 得文件TEND_drug_indication.txt 
复制 "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/clinical.trial/result_NCDid_title_phase_drug_disease_diseaseterm" 得文件clinical.trial-drug-indication.txt
step1：将interactions_v3.tsv中的drug进行unique,如果chemblID为空的行，用$drug_claim_name进行unique，把interactions_v3.tsv中没有的drugbank的数据也通过chemleid或者drugname纳入进来，得到文件step1-interactions_v3-uni-drug_database.txt。
step2：测试$drug_claim_name那一列有没有空值，结果显示没有空值。
step3:将step1-interactions_v3-uni-drug_database.txt中的drug-name或chembl,不加数据库名字去重输出。得文件step3-uni-drug.txt，共14378行。
step4:将以上五个文件的drug-indication追加输出到一个文件中，得文件all-step2_result_drug_indication.提取每个数据库中的chembl_id, drug_claim_name, indication及database.得step4_all_drug_indication.txt。
step5:将step1-interactions_v3-uni-drug_database.txt和step4_all_drug_indication.txt，交叉验证，查看有多少数据有drug-indication,多少没有drug-indication。分别得文件step5_all_drug_indication1.txt， step5_all_drug_indication2.txt， step5_all_drug_unmatch_indication.txt。
step6:将step5_all_drug_unmatch_indication.txt中的drug-name或chembl,不加数据库名字去重输出。得文件step6-uni-unmatchdrug.txt。共9247行。
step7:将step5中step5_all_drug_unmatch_indication.txt没有indication的药物用clinical.trial进行匹配，得文件step7_drug_indication.txt,和step7_drug_unmatch_indication.txt
step8:将:将step7_drug_unmatch_indication.txt中的drug-name或chembl,不加数据库名字去重输出。得文件step8-uni-unmatchdrug.txt。共9115行。
step9:复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/Chembl-indication/assays.txt" 得文件chembl_assay.txt 没有题头，在文件的开头有提到。
      用chembl_assay.txt中chembl_id，description，assay_organism这几列提出来。用chembl_id与step7_drug_unmatch_indication.txt相匹配。得文件step9_drug_indication.txt，筛选到两个药物。和文件step9_drug_unmatch_indication.txt。
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/drugCentral/struct_id-drug_active_name-drug_substance_name_disease_concept_name-disease_full_name" 得文件drugcentral_drug_indication.txt
step10:将step9中step9_drug_unmatch_indication.txt没有indication的药物用drugcentral_drug_indication.txt进行匹配，得文件step10_drug_indication2.txt和step10_drug_indication1.txt,共匹配到药物2个。和step10_drug_unmatch_indication.txt
step11：将step10_drug_unmatch_indication.txt中的drug-name或chembl,不加数据库名字去重输出。得文件step11-uni-unmatchdrug.txt。共9113行。
step12:将step10_drug_unmatch_indication.txt中的药物在Drugbank_drug_indication.txt进行匹配，查看没有indication的药物的stage,比如实验阶段。