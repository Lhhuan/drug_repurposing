cp "/f/mulinlab/huan/All_result_ICGC/network/original_network_num.txt" ./output/  #复制本底网络
cp "/f/mulinlab/huan/All_result_ICGC/network/network_gene_num.txt" ./output/
perl 03_map_drug_target_num.pl ###把./output/../../refined_huan_target_drug_indication_final_symbol.txt 的每个drug的所有target(entrez_id)都转换成在网络中的编号，得文件./output/03_huan_drug_target_num.txt
perl 04_emerge_huan_drug_rwr_and_run_rwr.pl   #把./output/../../refined_huan_target_drug_indication_final_symbol.txt 的每个drug的所有target作为group走rwr,并把结果存在./output/huan_data_rwr/rwr_result/ 文件夹下面


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
