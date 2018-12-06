#RepurposeDB_CGEA.txt包含drug_name 和target的信息，
#RepurposeDB_Triples.txt包含rxid， primary_disease, repo_disease,
#RepurposeDB_Evidence_Types.txt包含rxid,drug_name, number_of_drug_target
#perl 01_get_test_start_end.pl ##将RepurposeDB_CGEA.txt，RepurposeDB_Triples.txt和RepurposeDB_Evidence_Types.txt三个文件merge 到一起，然后与包含repodisease_gene的关系curated_gene_disease_associations.tsv
perl 01_get_two_disease.pl
cat 01_NofPmids3_disease.txt | sort -u > uni_NofPmids3_disease.txt
cat 01_drug_target2_repodisease.txt | sort -u > uni_repodisease.txt
perl "/f/mulinlab/huan/All_result/network/rwr_parameter_optimization/repodb_disgenet/mapin/disease_gene/01.pl"
perl "/f/mulinlab/huan/All_result/network/rwr_parameter_optimization/repodb_disgenet/mapin/repodisease/01.pl"

perl 02_get_test_start_end.pl #将drugtarget大于等于2的repo文件01_drug_target2_repo_disease.txt，对其diease进行mapin，经处理得文件"./mapin/repodisease/01_repodisease_indication_do_term.txt"
#将nofPmid大于等于3的文件01_nofPmid3_disease_gene.txt对其diease进行mapin，经处理得文件"./mapin/disease_gene/01_NofPmids3_disease_indication_do_term.txt";
#两边disease取交集，得02_uni_repo_drug.txt"; #输出满足条件的药物，02_uni_start.txt"; ##输出满足条件的start，得02_uni_end.txt"; ##输出，满足条件的end，得02_uni_start_end.txt"; #输出，满足条件的start_end_pair

 
 #一起找出网络中调参用的start,end得文件02_uni_start_end.txt和unique的end文件，02_uni_end.txt
Rscript 02_transfrom_end_symbol_entrezid.R #将02_uni_end.txt的symbol转换成entrezid,得02_unique_end_symbol_to_entrez.txt
perl 03_map_entrezid_to_end.pl #把02_uni_start_end.txt的end换成entrezid；得文件03_test_start_end_entrezid.txt
#cp "/f/mulinlab/huan/All_result/network/network_gene_num.txt" ./
perl 04_map_start_end_num.pl #把03_test_start_end_entrezid.txt与网络中的id匹配上。得文件04_test_start_end_num.txt。 312个pair
cat 04_test_start_end_num.txt | sort -t $'\t' -k1,1n -k2,2n > 04_test_start_end_num_sorted.txt
cat 04_test_start_end_num.txt | awk '{FS=" "}{print $1}'|sort -u |sort -k1,1n > uniq_test_start_sorted.txt #得到unique的test_start的排序文件 有44个start， 用作rwr中的起点。
cat 04_test_start_end_num.txt | awk '{FS=" "}{print $2}'|sort -u |sort -k1,1n > uniq_test_end_sorted.txt # 得到unique的test_end的排序文件 有54个end。一共构成了312个pair
# 因为之前算的都是单个start和单个end，下面的是以多个start为集合作为一个start（比如，一个药物有多个靶，就以多个靶为集合作为start ）
perl 05_map_entrezid_to_end_group.pl #把02_uni_start_end_info.txt的end换成entrezid；得文件05_test_start_end_entrezid_group.txt
perl 06_map_start_end_num.pl ##把05_test_start_end_entrezid_group.txt与网络中的id匹配上。得文件06_test_start_end_num.txt。
cat 06_test_start_end_num.txt | sort -t $'\t' -k1,1d > 06_test_start_end_num_sorted.txt
cat 06_test_start_end_num_sorted.txt | perl -ane 'chomp;@f=split/\t/;print "$f[0]\n"'| sort -u > unique_test_drug.txt #共14个drug   

cat result_restart0.5.txt | sort -k3,3nr > result_restart0.5_sorted.txt
cat result_restart0.6.txt | sort -k3,3nr > result_restart0.6_sorted.txt
cat result_restart0.7.txt | sort -k3,3nr > result_restart0.7_sorted.txt
cat result_restart0.8.txt | sort -k3,3nr > result_restart0.8_sorted.txt
cat result_restart0.9.txt | sort -k3,3nr > result_restart0.9_sorted.txt