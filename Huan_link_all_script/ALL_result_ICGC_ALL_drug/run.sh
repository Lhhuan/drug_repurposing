cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/step8_no_indication_drug.txt" ./no_indication_drug.txt

#cut drug name for sinan to find drug target score from DGIDB
cat no_indication_drug.txt |head -1 | cut -f1,9,10,11,12  >unique_no_indication_drug_need_to_find_drug_target_score.txt
cat no_indication_drug.txt | awk 'NR>1'|cut -f1,9,10,11,12 | sort -u >>unique_no_indication_drug_need_to_find_drug_target_score.txt
#------------------------------------------