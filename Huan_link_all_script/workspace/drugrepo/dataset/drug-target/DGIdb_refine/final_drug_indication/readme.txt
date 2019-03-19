复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/step2_result_gene_drug.txt"得Drugbank_drug_indication.txt.
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/TTD-indication/step2_result_TTD-gene-indication"得TTD-drug_indication.txt
复制 "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/GuideToPharmacologyInteractions/step2_result_drug_indication" 得GuideToPharmacology-drug_indication.txt
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/Chembl-indication/step2-result.txt"得chembl1-drug_indication.txt
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/Chembl-indication/step4-result.txt"得文件chembl2-drug_indication.txt
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/TdgClinicalTrial/step2_result_drug_indication" 得文件TdgClinicalTrial-drug_indication.txt
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/TEND/step2_result_drug_indication.txt" 得文件TEND_drug_indication.txt 
复制 "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/clinical.trial/result_NCDid_title_phase_drug_disease_diseaseterm" 得文件clinical.trial-drug-indication.txt
step1：将interactions_v3.tsv中的drug进行unique,如果chemblID为空的行，用$drug_claim_name进行unique，把interactions_v3.tsv中没有的drugbank的数据也通过chemleid或者drugname纳入进来，得到文件step1-interactions_v3-uni-drug_database.txt。
step4:将以上五个文件的drug-indication追加输出到一个文件中，得文件all-step2_result_drug_indication.提取每个数据库中的chembl_id, drug_claim_name, indication及database.得step4_all_drug_indication.txt。
step5:将step1-interactions_v3-uni-drug_database.txt和step4_all_drug_indication.txt，交叉验证，查看有多少数据有drug-indication,多少没有drug-indication。分别得文件step5_all_drug_indication1.txt， step5_all_drug_indication2.txt， step5_all_drug_unmatch_indication.txt。
step7:将step5中step5_all_drug_unmatch_indication.txt没有indication的药物用clinical.trial进行匹配，得文件step7_drug_indication.txt,和step7_drug_unmatch_indication.txt

step9:复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/Chembl-indication/assays.txt" 得文件chembl_assay.txt 没有题头，在文件的开头有提到。
      用chembl_assay.txt中chembl_id，description，assay_organism这几列提出来。用chembl_id与step7_drug_unmatch_indication.txt相匹配。得文件step9_drug_indication.txt，筛选到两个药物。和文件step9_drug_unmatch_indication.txt。
复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/drugCentral/struct_id-drug_active_name-drug_substance_name_disease_concept_name-disease_full_name" 得文件drugcentral_drug_indication.txt
step10:将step9中step9_drug_unmatch_indication.txt没有indication的药物用drugcentral_drug_indication.txt进行匹配，得文件step10_drug_indication2.txt和step10_drug_indication1.txt,共匹配到药物2个。和step10_drug_unmatch_indication.txt


        dgidb 从postgresql恢复得文件drugs.txt，drug_claims.txt，chembl_molecules.txt
step13：看文件step12_drug_unmatch_indication_out_drugbank.txt中drug的approval情况。得文件step13_chembl_exist.txt在chembl_molecules.txt中存在的step12_drug_unmatch_indication_out_drugbank.txt，共2993行，
        得文件 step13_chembl_unexist.txt在chembl_molecules.txt中不存在的step12_drug_unmatch_indication_out_drugbank.txt 共3593行。  得没有chembl_id的数据3593条。
step13-1：用文件step13_chembl_unexist.txt的drug_claim_name把文件interactions_v3.tsv中的drug_claim_primary_name对应提出。
          得在clinical.trial中有indication的文件step13-1_drug-indication-exist.txt,共236行。得在clinical.trial中没有indication的文件step13-1_drug_no_indication.txt 共3545行。
          得在interactions_v3.tsv中不中存在的drug_claim_primary_name的文件step14-1_no_drug-name.txt，此文件为空。
step14：从step13_chembl_exist.txt中得到有indication文件的step14_chembl_exist_indication.txt 共464行。
        得到没有indication的信息，但是max_phase > 0的文件step14_chembl_unexist_phase_0.txt， 共637行。
        得到没有indication的信息，并且max_phase=0的文件step14_chembl_unexist_phase=0.txt， 共1892行。
step14-1：用文件step14_chembl_unexist_phase=0.txt的drug_claim_name把文件interactions_v3.tsv中的drug_claim_primary_name对应提出。
        得在clinical.trial中有indication的文件step14-1_drug-indication-exist.txt,共250行. 得在clinical.trial 中不存在indication的文件step14-1_drug_no_indication.txt， 共1858行
step14-2：查看step14-1_drug_no_indication.txt中的chembl_id在chembl_indications-17_13-38-29.txt中是否存在。 得到有indication的文件step14-2_drug-indication-exist.txt，共9行。
        得到没有indication的文件step14-2_drug_no_indication.txt，共1850行。
step15：用step14_chembl_unexist_phase_0.txt中的chembl-id提出interactions_v3.tsv所对应的drug_name,然后查询这些drug_name在clinical.trial-drug-indication.txt中有木有。
        得到三个文件step15_drug-indication-exist.txt，共有drug-indication pair 一共有1298行。
        得到在clinical.trial中没有indication的文件step15_drug_no_indication.txt ， 共有593行。
        得到文件step15_no_drug-name.txt，里面数据为空。

step16.pl :相比于step15.pl step16将my $drug_claim_name = $f[5]换成$drug_claim_primary_name =$f[6]
        得到三个文件step16_drug-indication-exist.txt，共有drug-indication pair 一共有1406行。
        得到在clinical.trial中没有indication的文件step16_drug_no_indication.txt ， 共有569行。
        得到文件step16_no_drug-name.txt，里面数据为空。

cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/Chembl-indication/chembl_indications-17_13-38-29.txt"  chembl_indications-17_13-38-29.txt
step17.pl: 查看step16_drug_no_indication.txt中的chembl_id在chembl_indications-17_13-38-29.txt中是否存在。
        得文件，在chembl中有indication的文件step17_drug-indication-exist.txt ，共207行。
        得文件在chembl中没有indication的文件step17_drug_no_indication.txt，共471行
为文件step17_drug_no_indication.txt在chembl中按照chembl_id查找出药物在clinical中的名字(增加了最后一列$drug_synonyms_name)，得文件step17_drug_no_indication-mannual-name.txt。


step18.pl:

step19.pl :用文件step17_drug_no_indication-mannual-name.txt。与clinical.trial-drug-indication.txt 交叉查询，得在clinical.trial-drug-indication.txt有indication的药物，得文件step19_drug-indication-exist.txt, 共3855行。
           得在clinical.trial-drug-indication.txt没有indication的药物文件step19_drug_no_indication.txt，共243行。手动为这243行中drug_synonyms_name不为NA的找indication得文件step19_drug_no_indication_mannal.txt和文件step19_drug_no_indication_mannal-1.txt。
           为寻找indication得文件step19_drug_no_indication-mannual-3.txt(其中drug_another_chembl_id为一个化合物，由于加了一些修饰，比如盐酸等造成的chembl_id不同，在这一列有chembl有id的在drugbank中都出现，可以直接丢掉。)step19_drug_no_indication-mannual-3.txt为
           直接在step19_drug_no_indication.txt加indication的文件。

step20.pl: 把step19找出的indication合并，即将文件step19_drug_no_indication_mannal.txt和文件step19_drug_no_indication_mannal-1.txt以及step19_drug_no_indication-mannual-3.txt 中有indication 的药物合并，得有indication的药物文件step20_drug-indication-exist.txt
step21.pl : 找出 step19_drug_no_indication.txt中没有indication的药物。 得到文件step21_drug-indication-unexist.txt。共143个药物。
   
   并将没有在indication的药物另外输出（step19_drug_no_indication.txt实在找不到indication的文件。）
           



得到没有indication的药物一共有8134，其中包括2685个来源于drugbank处于experiment阶段。3545个没有chembl_id, 还有1850个处于phase0阶段。143个phase<4,且在clinical中没有indication的药物，共143个。
一共药物是14379个，减掉22个重复的，还剩14357个，没有indication的药物一共有8134个，占56.57%，有indication的药物有43.43%

复制"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/step4_drugbank_drug_gene_entrez_id.txt" 得文件drugbank_drug_gene_entrez_id.txt
用statistic.pl 改step1.pl的脚本，获得unique的drug-interaction的pair.  有entrez_id的按entrez_id去重，没有的按照gene_claim_name去重, 得文件statistic-drug_gene.txt 
用statistic1.pl 将文件statistic-drug_gene.txt中的基因以及gene_drug的pair进行unique。得文件statistic1-uni_drug_gene.txt 共46032行 ，statistic1-uni_gene.txt得共4190行。
uni-drug-1

得到没有indication数据一共有8223，其中包括2685个来源于drugbank处于experiment阶段。3545来源于没有chembl_id, 还有1850个处于phase0阶段。143个phase<4,且在clinical中没有indication的药物，共143个。


statistic_drug_indi.pl 得文件all1_statistic_uni_drug_indication.txt, 14700 all1_statistic_uni_drug.txt, 共3799个 all1_statistic_uni_indication.txt 共4415行



以下路径的文件为uni-drug-2收集到的drug_indication
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step5_all_drug_indication1.txt" step5_all_drug_indication1.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step5_all_drug_indication2.txt" step5_all_drug_indication2.txt
 
 
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step7_drug_indication.txt"   step7_drug_indication.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step9_drug_indication.txt"  step9_drug_indication.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step10_drug_indication2.txt"  step10_drug_indication2.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step10_drug_indication1.txt" step10_drug_indication1.txt

 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step13-1_drug-indication-exist.txt" step13-1_drug-indication-exist.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step14_chembl_exist_indication.txt" step14_chembl_exist_indication.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step14-1_drug-indication-exist.txt" step14-1_drug-indication-exist.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step14-2_drug-indication-exist.txt" step14-2_drug-indication-exist.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step15_drug-indication-exist.txt"  step15_drug-indication-exist.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step16_drug-indication-exist.txt"  step16_drug-indication-exist.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step17_drug-indication-exist.txt"  step17_drug-indication-exist.txt
 cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step20_drug-indication-exist.txt"  step20_drug-indication-exist.txt
