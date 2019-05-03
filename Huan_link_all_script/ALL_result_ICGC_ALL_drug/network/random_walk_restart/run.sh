cp "/f/mulinlab/huan/All_result_ICGC/network/original_network_num.txt" ./output/  #复制本底网络
cp "/f/mulinlab/huan/All_result_ICGC/network/network_gene_num.txt" ./output/
perl 03_map_drug_target_num.pl ###把./output/../../refined_huan_target_drug_indication_final_symbol.txt 的每个drug的所有target(entrez_id)都转换成在网络中的编号，得文件./output/03_huan_drug_target_num.txt
perl 04_emerge_huan_drug_rwr_and_run_rwr.pl   #把./output/../../refined_huan_target_drug_indication_final_symbol.txt 的每个drug的所有target作为group走rwr,并把结果存在./output/huan_data_rwr/rwr_result/ 文件夹下面
 #perl 04_emerge_huan_drug_rwr_and_run_rwr_parallel.pl 是 04_emerge_huan_drug_rwr_and_run_rwr.pl的多线程
perl 05_filter_rwr_result_top_0.044.pl #把./output/huan_data_rwr/rwr_result/${drug}_sorted.txt 里面的每个drug rwr result,取top4.4%， 把筛选结果放在./output/huan_data_rwr/rwr_result_top_0.044/
perl 06_filter_rwr_start_result_top_0.044.pl #./output/huan_data_rwr/rwr_result_top_0.044/${drug}.txt 中出现的./output/huan_data_rwr/start/${drug}.txt 去掉，得./output/huan_data_rwr/rwr_result_top_0.044_no_start/${drug}.txt 
perl 07_icgc_snv_indel_overlap_rwr_result.pl #对于每个药物，./output/huan_data_rwr/rwr_result_top_0.044_no_start/${drug}.txt 文件与../output/04_map_ICGC_snv_indel_in_network_num.txt 的交集，得文件./output/huan_data_rwr/rwr_result_top_0.044_no_start_overlap_ICGC_SNV_Indel/${drug}.txt
perl 08_all_probality_start_end.pl  #对于每个药物，用./output/huan_data_rwr/start/${drug}.txt和./output/huan_data_rwr/rwr_result_top_0.044_no_start_overlap_ICGC_SNV_Indel/${drug}.txt 
#穷举出所有的start和end pair, 用于走最短路径文件存到./output/huan_data_rwr/the_shortest_path_start_end/${drug}.txt ，得总文件./output/08_drug_start_end_pair_to_shortest.txt，和逗号分割start的文件./output/08_drug_start_comma_end.txt
cat ./output/08_drug_start_end_pair_to_shortest.txt | perl -ane 'chomp;unless(/^drug/){@f=split/\t/;print"$f[1]\t$f[2]\n"}' | sort -u > ./output/08_uni_start_end_shortest.txt #start 和end 的unique的文件。
Rscript 09_run_the_shortest_path.R  #走最短路径。因为此步骤比较长，所以用多线程在./tmp_shortest_path_data/中跑。


perl 9.21_drug_target_num.pl #把./output/03_huan_drug_target_num.txt中每个文件对应的start(target)的个数统计出来，得./output/9.21_drug_target_num.txt 同时得./output/9.21_drug_num.txt
perl 9.22_random_select_start.pl #把按照./output/9.21_drug_num.txt的数据个数随机选择选择start个数1000次，文件在./output/huan_data_rwr/random_select/start/${num}/start${i}.txt
    sed -n '1,6p' ./output/9.21_drug_num.txt > ./output/9.211_drug_num.txt
    sed -n '7,12p' ./output/9.21_drug_num.txt >./output/9.212_drug_num.txt
    sed -n '13,18p' ./output/9.21_drug_num.txt >./output/9.213_drug_num.txt
    sed -n '19,24p' ./output/9.21_drug_num.txt >./output/9.214_drug_num.txt
    sed -n '25,30p' ./output/9.21_drug_num.txt >./output/9.215_drug_num.txt
    sed -n '31,36p' ./output/9.21_drug_num.txt >./output/9.216_drug_num.txt
    sed -n '37,42p' ./output/9.21_drug_num.txt >./output/9.217_drug_num.txt
    sed -n '43,48p' ./output/9.21_drug_num.txt >./output/9.218_drug_num.txt
    sed -n '49,54p' ./output/9.21_drug_num.txt >./output/9.219_drug_num.txt
    sed -n '55,60p' ./output/9.21_drug_num.txt >./output/9.2110_drug_num.txt
perl 9.23_random_start_rwr.pl #以./output/huan_data_rwr/random_select/start/${num}/start${i}.txt 为起点走rwr,结果为./output/huan_data_rwr/random_select/rwr_result/${num}/result${i}.txt,
#得排序文件./output/huan_data_rwr/random_select/rwr_result/${num}/result${i}_sorted.txt
    perl 9.231_random_start_rwr.pl
    perl 9.232_random_start_rwr.pl
    perl 9.233_random_start_rwr.pl
    perl 9.234_random_start_rwr.pl
    perl 9.235_random_start_rwr.pl
    perl 9.236_random_start_rwr.pl
    perl 9.237_random_start_rwr.pl
    perl 9.238_random_start_rwr.pl
    perl 9.239_random_start_rwr.pl
    perl 9.2310_random_start_rwr.pl
    perl 9.24_random_select_filter_rwr_result_top_0.044.pl #把./huan_data_rwr/random_select/rwr_result/${num}/result${i}_sorted.txt 里面的每个文件,取top4.4%， 
    #把筛选结果放在./huan_data_rwr/random_select/rwr_result_top_0.044/${num}/result${i}.txt
perl 9.25_random_overlap_fact.pl #利用记录drug target 数目的文件./output/9.21_drug_target_num.txt，把./output/huan_data_rwr/random_select/rwr_result_top_0.044/${num}/result${i}.txt 和./output/08_drug_start_comma_end.txt中的end 取交集。得文件./output/9.25_random_overlap_fact.txt
#----------------------------------------因为多线程会存在结果不稳定的情况，所以这里把输入文件拆分，进行手动多线程在9.25_random_overlap_fact 文件夹中进行多线程并行。
