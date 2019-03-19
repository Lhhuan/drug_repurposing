
#因drugbank中药物有更新，所以这里的数目统计和readme中的数目统计不相同
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/step2_result_gene_drug.txt" Drugbank_drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/TTD-indication/step2_result_TTD-gene-indication.txt" TTD-drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/GuideToPharmacologyInteractions/step2_result_drug_indication.txt" GuideToPharmacology-drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/Chembl-indication/step2-result.txt" chembl1-drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/Chembl-indication/step4-result.txt" chembl2-drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/TdgClinicalTrial/step2_result_drug_indication.txt" TdgClinicalTrial-drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb_refine/TEND/step2_result_drug_indication.txt"  TEND_drug_indication.txt 
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/clinical.trial/result_NCDid_title_phase_drug_disease_diseaseterm" clinical.trial-drug-indication.txt
# perl step1.pl #将interactions_v3.tsv中的drug进行unique,如果chemblID为空的行，用$drug_claim_name进行unique，把interactions_v3.tsv中没有的drugbank的数据也通过chemleid或者drugname纳入进来，
perl step4.pl #将以上五个文件的drug-indication追加输出到一个文件中，得文件all-step2_result_drug_indication.提取每个数据库中的chembl_id, drug_claim_name, indication及database.得step4_all_drug_indication.txt。

perl step5.pl #将step1-interactions_v3-uni-drug_database.txt和step4_all_drug_indication.txt，
#查看有多少数据有drug-indication,多少没有drug-indication。分别得文件step5_all_drug_indication1.txt， step5_all_drug_indication2.txt， step5_all_drug_unmatch_indication.txt。
perl step7.pl #:将step5中step5_all_drug_unmatch_indication.txt没有indication的药物用clinical.trial进行匹配，得文件step7_drug_indication.txt,和step7_drug_unmatch_indication.txt
perl step9.pl #:复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/Chembl-indication/assays.txt" 得文件chembl_assay.txt 没有题头，在文件的开头有提到。
      #用chembl_assay.txt中chembl_id，description，assay_organism这几列提出来。用chembl_id与step7_drug_unmatch_indication.txt相匹配。得文件step9_drug_indication.txt，筛选到两个药物。和文件step9_drug_unmatch_indication.txt。
#复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/drugCentral/struct_id-drug_active_name-drug_substance_name_disease_concept_name-disease_full_name" 得文件drugcentral_drug_indication.txt
perl step10.pl #将step9中step9_drug_unmatch_indication.txt没有indication的药物用drugcentral_drug_indication.txt进行匹配，
#得文件step10_drug_indication2.txt和step10_drug_indication1.txt,共匹配到药物2个。和step10_drug_unmatch_indication.txt
perl step11.pl #将step10_drug_unmatch_indication.txt中的drug-name或chembl,不加数据库名字去重输出。得文件step11-uni-unmatchdrug.txt。共9229-1 =9228行。
perl step12.pl #将step10_drug_unmatch_indication.txt中的药物在Drugbank中查看没有indication的药物的stage,比如实验阶段。得文件step12_drug_unmatch_indication_in_drugbank-expri.txt， 发现2815-1= 2814个药物都是实验阶段的。
        #并且将不是Drugbank来源的筛选出来得文件step12_drug_unmatch_indication_out_drugbank.txt。
 #从postgresql恢复得文件drugs.txt，drug_claims.txt，chembl_molecules.txt
perl step13.pl #：看文件step12_drug_unmatch_indication_out_drugbank.txt中drug的approval情况。得文件step13_chembl_exist.txt在chembl_molecules.txt中存在的step12_drug_unmatch_indication_out_drugbank.txt，共2991-1=2990行，
        #得文件 step13_chembl_unexist.txt在chembl_molecules.txt中不存在的step12_drug_unmatch_indication_out_drugbank.txt 共行3594-1 = 3593。  得没有chembl_id的数据条。
perl step13-1.pl #：用文件step13_chembl_unexist.txt的drug_claim_name把文件interactions_v3.tsv中的drug_claim_primary_name对应提出。
          #得在clinical.trial中有indication的文件step13-1_drug-indication-exist.txt,共236行。得在clinical.trial中没有indication的文件step13-1_drug_no_indication.txt 共3546-1 = 3545行。
          #得在interactions_v3.tsv中不中存在的drug_claim_primary_name的文件step14-1_no_drug-name.txt，此文件为空。
perl step14.pl #：从step13_chembl_exist.txt中得到有indication文件的step14_chembl_exist_indication.txt 共465-1 = 464行。
        # 得到没有indication的信息，但是max_phase > 0的文件step14_chembl_unexist_phase_0.txt， 共635-1 = 634行。
        # 得到没有indication的信息，并且max_phase=0的文件step14_chembl_unexist_phase=0.txt， 共1893-1 = 1892行。
perl step14-1.pl #：用文件step14_chembl_unexist_phase=0.txt的drug_claim_name把文件interactions_v3.tsv中的drug_claim_primary_name对应提出。
        #得在clinical.trial中有indication的文件step14-1_drug-indication-exist.txt,共251-1=250行. 得在clinical.trial 中不存在indication的文件step14-1_drug_no_indication.txt， 共1859-1 = 1858行
perl step14-2.pl #：查看step14-1_drug_no_indication.txt中的chembl_id在chembl_indications-17_13-38-29.txt中是否存在。 得到有indication的文件step14-2_drug-indication-exist.txt，共10-1=9行。
        #得到没有indication的文件step14-2_drug_no_indication.txt，共1851-1 = 1850行。

