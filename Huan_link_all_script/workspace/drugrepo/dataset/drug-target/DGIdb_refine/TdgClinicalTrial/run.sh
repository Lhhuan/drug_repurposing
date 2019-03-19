perl step1.pl #：将interactions_v3.tsv的TdgClinicalTrial部分筛选出，得文件interactions_v3-TdgClinicalTrial.txt。
perl step2.pl #：通过药物名字，将药物和适应症联系起来。
#    得到药物和适应症匹配的文件step2_result_drug_indication.txt。得到1127个药物。
#    得到没有匹配到药物的适应症的文件，step2_unmatch_drug.txt，得到1149个药物。