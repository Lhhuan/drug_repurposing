cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/interactions_v3.tsv" dgidb_interactions_v3.tsv

cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/step10-3_all_target_drug_indication.txt" huan_target_drug_indication.txt

#cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/step1-interactions_v3_drug_target_database.txt"  DGIdb_all_drug_target.txt

cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/step1-interactions_v3_drug_target_database.txt" dgidb_drugbank.txt


01_filter_drug_exist.pl
看 Repurposing_Hub_export.txt在DGIdb及我们自己整理的数据库的收集情况，得在我们自己整理的数据库中存在的数据：01_exist_huan.txt， 得在我们自己的数据库中不存在，但是在DGIdb中存在的数据:01_out_huan_exist_dgidb.txt
得在DGIdb中不存在的数据：01_no_exist_dgidb.txt

02_filter_indication.pl
筛选文件中indication和target数据
没有indication的01_out_huan_exist_dgidb.txt  得文件 02_out_huan_exist_dgidb_no_indication.txt 这个文件不要
有indication，没有target的01_out_huan_exist_dgidb.txt 得文件 02_out_huan_exist_dgidb_indication_no_target.txt 这个文件留下，找target
有indication、有target的01_out_huan_exist_dgidb.txt 得文件 02_out_huan_exist_dgidb_indication_target.txt 这个文件的数据直接收
没有indication的01_no_exist_dgidb.txt 得文件 02_no_exist_dgidb_no_indication.txt 这个文件不要
有indication，没有target的01_no_exist_dgidb.txt    02_no_exist_dgidb_indication_no_target.txt 这个文件也不留下
有indication、有target的01_no_exist_dgidb.txt 得文件 02_no_exist_dgidb_indication_target.txt 这个文件的数据直接收

03_find_target.pl 为没有indication的文件02_out_huan_exist_dgidb_indication_no_target.txt药物寻找target，得有target的文件03_find_drug.txt
04_merge_drug.pl 将02_no_exist_dgidb_indication_target.txt 02_out_huan_exist_dgidb_indication_target.txt 和 03_find_drug.txt中target不为unknown的drug输出到一个文件04_drug_target_indication.txt


cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/CLUE_REPURPOSING/02_no_repeat_hub.txt" no_repeat_hub.txt
得CLUE_REPURPOSING文件夹中筛出来的数据no_repeat_hub.txt

05_find_diff.pl 寻找no_repeat_hub.txt和04_drug_target_indication.txt的差异,得05_differ.txt有五行和05_common.txt 有267行，所以no_repeat_hub.txt全部落在04_drug_target_indication.txt里。
06_merge_durg.pl 将02_no_exist_dgidb_indication_target.txt 02_out_huan_exist_dgidb_indication_target.txt 和 03_find_drug.txt中target不为unknown的drug等信息输出到一个文件06_drug_target_indication.txt