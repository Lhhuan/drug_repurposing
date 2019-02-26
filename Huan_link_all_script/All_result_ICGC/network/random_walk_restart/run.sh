cp "/f/mulinlab/huan/All_result_ICGC/network/original_network_num.txt" ./  #复制本底网络

#-----------------------------------------------------优化cutoff
perl 01_emerge_rwr_start_and_run_rwr.pl #把每个drug的所有target作为group走rwr,并把结果存在parameter_optimization/top/rwr_result文件夹下面。
##############################02_filter_cutoff.pl #cutoff 取top 0.0001-0.1时，每个cutoff时，drug所hit到的all repo disease gene的数目，得文件drug_hit_all_repo_gene_count_result.txt
perl 02_cutoff_repo_gene_count.pl # #cutoff 取top 0.0001-0.1时，每个cutoff时，drug所对应的每个repo rwr结果hit住每个drug repo的disease gene的个数，得文件"./parameter_optimization/top/hit_result/02_drug_hit_repo_and_gene.txt";
##在不同cutoff下，rwr结果hit住repo 时，hit住几个基因，并算出要做Fisher exact test时所需的ABC
cd ./parameter_optimization/top/hit_result/
Rscript fisher_test.R #得到文件"/media/mulinlab/Data02/huan/All_result/network/random_walk_restart/parameter_optimization/top/hit_result/fisher_test_result.txt"
cat fisher_test_result.txt | perl -ane 'chomp; @f= split/\t/;if($f[3]<0.05){print "$_\n"}' >fisher_test_result_p_small_than0.05.txt #得P<0.05的文件fisher_test_result_p_small_than0.05.txt
perl 02_cutoff_p_significant_count.pl ##把不同cutoff时，p值显著的drug repo pair计数。得文件02_cutoff_p_significant_count.txt
cat 02_cutoff_p_significant_count.txt | sort -k1,1g > 02_sorted_cutoff_p_significant_count.txt #按照cutoff从低到高排序
#以02_sorted_cutoff_p_significant_count.txt的cutoff为横坐标，count为纵坐标作图，得02_sorted_cutoff_p_significant_count_map.xlsx，图在sheet1，图并不显著，所以把把02_cutoff_p_significant_count.txt的count值从大到小排序

cat 02_cutoff_p_significant_count.txt | sort -k2,2rg -k1,1g > 02_sorted_count__cutoff_p_significant_count.txt  #把02_cutoff_p_significant_count.txt的count值从大到小排序。得到文件02_sorted_count__cutoff_p_significant_count.txt
#发现cutoff 为 0.044 0.0441 0.0442 0.0439时，drug repo pair最高，为185,,百分比为73.90所以最终选0.044为cutoff
cd ..
#此时目录为/f/mulinlab/huan/All_result_ICGC/network/random_walk_restart/parameter_optimization/top/
#-------------------------------------------------------------------------------------测试设计的打分系统的逻辑是否正确。
perl 021_drug_target_num.pl #统计"/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt"中drug target的数目。
#得021_drug_target_num.txt,得target :021_target_num.txt,同时得drug及target的信息，得文件021_drug_target.txt

perl 0211_drug_end.pl #把金标准数据，用rwr走出来的结果取0.044时overlap的结果，利用./hit_result/02_drug_hit_repo_and_gene.txt，得0211_gold_standard_overlap_rwr.txt 即用rwr top 0.044时能捕获到的金标准的数据。
perl 022_random_select_start.pl #把按照021_target_num.txt的数据个数随机选择选择start个数1000次，文件在./random_select/start/${num}/start${i}.txt
    #---------------------------------------------
    sed -n '1,3p' 021_target_num.txt >0211_drug_num.txt
    sed -n '4,6p' 021_target_num.txt >0212_drug_num.txt
    sed -n '7,9p' 021_target_num.txt >0213_drug_num.txt
    sed -n '10,12p' 021_target_num.txt >0214_drug_num.txt
    sed -n '13,15p' 021_target_num.txt >0215_drug_num.txt
    sed -n '16,18p' 021_target_num.txt >0216_drug_num.txt
    sed -n '19,21p' 021_target_num.txt >0217_drug_num.txt
    sed -n '22,24p' 021_target_num.txt >0218_drug_num.txt
    sed -n '25,27p' 021_target_num.txt >0219_drug_num.txt
    sed -n '28,31p' 021_target_num.txt >02110_drug_num.txt
perl 023_random_start_rwr.pl #以./random_select/start/${num}/start${i}.txt 为起点走rwr,结果为./random_select/rwr_result/${num}/result${i}.txt,得排序文件./random_select/rwr_result/${num}/result${i}_sorted.txt   
    perl 0231_random_start_rwr.pl
    perl 0232_random_start_rwr.pl
    perl 0233_random_start_rwr.pl
    perl 0234_random_start_rwr.pl
    perl 0235_random_start_rwr.pl
    perl 0236_random_start_rwr.pl
    perl 0237_random_start_rwr.pl
    perl 0238_random_start_rwr.pl
    perl 0239_random_start_rwr.pl
    perl 02310_random_start_rwr.pl
perl 024_random_select_filter_rwr_result_top_0.044.pl ##把./random_select/rwr_result/${num}/result${i}_sorted.txt 里面的每个文件,取top4.4%， 把筛选结果放在./random_select/rwr_result_top_0.044/${num}/result${i}.txt
perl 025_random_overlap_fact.pl #利用记录drug target 数目的文件021_drug_target_num.txt，把./random_select/rwr_result_top_0.044/${num}/result${i}.txt 和0211_gold_standard_overlap_rwr.txt中的end 取交集。得文件025_random_overlap_fact.txt
perl 026_count_random_overlap_fact.pl #为025_random_overlap_fact.txt，为每个drug对应的random_overlap_fact出现的end计数，得文件026_drug_count_random_overlap_fact.txt，同时得end计数重复出现频率即normal score 文件026_drug_network_disease_gene_normal_score.txt
cat 026_drug_network_disease_gene_normal_score.txt | sort -k1,1V -k3,3g >sorted_026_drug_network_disease_gene_normal_score.txt
#cat 0211_gold_standard_overlap_rwr.txt | cut -f2,4 | sort -u | sort -k1,1V -k3,3rg >123.txt
perl 027_all_probality_start_end_gold_standard.pl #用021_drug_target.txt和0211_gold_standard_overlap_rwr.txt找出的rwr 最短路径的组合,得文件027_gold_standard_shortest_pair.txt
cat 027_gold_standard_shortest_pair.txt | perl -ane 'chomp;unless(/^drug/){@f= split/\t/;print "$f[1]\t$f[2]\n"}' | sort -u >027_unique_start_end.txt
    sed -n '1,10000p' 027_unique_start_end.txt >./tmp_shortest_path/0271_unique_start_end.txt
    sed -n '10001,20000p' 027_unique_start_end.txt >./tmp_shortest_path/0272_unique_start_end.txt
    sed -n '20001,30000p' 027_unique_start_end.txt >./tmp_shortest_path/0273_unique_start_end.txt
    sed -n '30001,40000p' 027_unique_start_end.txt >./tmp_shortest_path/0274_unique_start_end.txt
    sed -n '40001,50000p' 027_unique_start_end.txt >./tmp_shortest_path/0275_unique_start_end.txt
    sed -n '50001,56520p' 027_unique_start_end.txt >./tmp_shortest_path/0276_unique_start_end.txt
    #在./tmp_shortest_path/028_run_the_shortest_path*.R里运行这些文件的最短路径。
cat ./tmp_shortest_path/028_the_shortest_path*.txt > 028_the_shortest_path.txt
perl 029_find_logic_of_the_shortest.pl #用"/f/mulinlab/huan/All_result_ICGC/network/the_shortest_path/normal_network_num.txt"为028_the_shortest_path.txt里面的最短路径寻找start和end的逻辑关系,得029_start_end_logical.txt
perl 0291_merge_drug_target_rwr_end_logic.pl #用027_gold_standard_shortest_pair.txt，029_start_end_logical.txt把符合条件的最短路径的drug_target_rwr_end逻辑根据特定药物merge产生，得0291_merge_drug_target_rwr_end_logic.txt
perl 0292_acquire_drug_target_score_and_edge_length.pl #0291_merge_drug_target_rwr_end_logic.txt利用"/f/mulinlab/huan/All_result_ICGC/brief_drug_target_info.txt"和"/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_all_sorted_drug_target_repo_symbol_entrez_num.txt"
#获取drug targetscore，利用028_the_shortest_path.txt获取最短路径中的长度。，得0292_acquire_drug_target_score_and_edge_length.txt
perl 0293_judge_per_drug_the_shortest_path_logic_rwr_end.pl #用0292_acquire_drug_target_score_and_edge_length.txt判断每个药物对于rwr的end的最短路径的逻辑关系。得0293_judge_per_drug_the_shortest_path_logic_rwr_end.txt
#---------------------------------------------------------------------------------------------
cd ..
cd ..
cd ..
#-------------------------------------------------------------------run 自己的data

perl 03_map_drug_target_num.pl ###把../../refined_huan_target_drug_indication_final_symbol.txt 的每个drug的所有target(entrez_id)都转换成在网络中的编号，得文件03_huan_drug_target_num.txt

perl 04_emerge_huan_drug_rwr_and_run_rwr.pl #把../../refined_huan_target_drug_indication_final_symbol.txt 的每个drug的所有target作为group走rwr,并把结果存在./huan_data_rwr/rwr_result/ 文件夹下面

perl 05_filter_rwr_result_top_0.044.pl #把.huan_data_rwr/rwr_result/${drug}_sorted.txt 里面的每个drug rwr result,取top4.4%， 把筛选结果放在./huan_data_rwr/rwr_result_top_0.044/
perl 06_filter_rwr_start_result_top_0.044.pl #./huan_data_rwr/rwr_result_top_0.044/${drug}.txt 中出现的./parameter_optimization/top/start/${drug}.txt 去掉，得./huan_data_rwr/rwr_result_top_0.044_no_start/${drug}.txt 
perl 07_icgc_snv_indel_overlap_rwr_result.pl #对于每个药物，./huan_data_rwr/rwr_result_top_0.044_no_start/${drug}.txt 文件与../04_map_ICGC_snv_indel_in_network_num.txt 的交集，得文件./huan_data_rwr/rwr_result_top_0.044_no_start_overlap_ICGC_SNV_Indel/${drug}.txt 
perl 08_all_probality_start_end.pl  #对于每个药物，用./huan_data_rwr/start/${drug}.txt和./huan_data_rwr/rwr_result_top_0.044_no_start_overlap_ICGC_SNV_Indel/${drug}.txt 
#穷举出所有的start和end pair, 用于走最短路径文件存到./huan_data_rwr/the_shortest_path_start_end/${drug}.txt ，得总文件08_drug_start_end_pair_to_shortest.txt，和逗号分割start的文件08_drug_start_comma_end.txt
cat 08_drug_start_end_pair_to_shortest.txt | perl -ane 'chomp;unless(/^drug/){@f=split/\t/;print"$f[1]\t$f[2]\n"}' | sort -u > 08_uni_start_end_shortest.txt #start 和end 的unique的文件。
#Rscript 09_run_the_shortest_path.R  走最短路径。因为此步骤比较长，所以用多线程在./tmp_shortest_path_data/中跑。
    cat ./tmp_shortest_path_data/09_the_shortest_path*.txt >09_the_shortest_path.txt    
Rscript 9.1_the_mean_shortest_length.R #计算网络中任意两点平均最短路径的长度，得网络中平均最短路径长度为3.606，并将此数字记录在文件9.1_the_mean_shortest_length.txt中。
#----------------------------------------------------------------------------------------------------------------  #因为start个数不同时，rwr的最高分数不同，所以不能normal，所以在这里做一种p值，p值越小，说明我们跑的rwr的结果越显著。可以用这里的p值进行排序
cat 08_drug_start_comma_end.txt | cut -f1,2 | sort -u > 08_drug_start_comma.txt
        perl 9.21_drug_target_num.pl  #把08_drug_start_comma.txt中每个文件对应的start(target)的个数统计出来，得9.21_drug_target_num.txt 同时得9.21_drug_num.txt
        perl 9.22_random_select_start.pl #把按照9.21_drug_num.txt的数据个数随机选择选择start个数1000次，文件在./huan_data_rwr/random_select/start/${num}/start${i}.txt
            sed -n '1,6p' 9.21_drug_num.txt >9.211_drug_num.txt
            sed -n '7,12p' 9.21_drug_num.txt >9.212_drug_num.txt
            sed -n '13,18p' 9.21_drug_num.txt >9.213_drug_num.txt
            sed -n '19,24p' 9.21_drug_num.txt >9.214_drug_num.txt
            sed -n '25,30p' 9.21_drug_num.txt >9.215_drug_num.txt
            sed -n '31,36p' 9.21_drug_num.txt >9.216_drug_num.txt
            sed -n '37,42p' 9.21_drug_num.txt >9.217_drug_num.txt
            sed -n '43,48p' 9.21_drug_num.txt >9.218_drug_num.txt
            sed -n '49,53p' 9.21_drug_num.txt >9.219_drug_num.txt
            sed -n '54,55p' 9.21_drug_num.txt >9.2110_drug_num.txt
        perl 9.23_random_start_rwr.pl #以./huan_data_rwr/random_select/start/${num}/start${i}.txt 为起点走rwr,结果为./huan_data_rwr/random_select/rwr_result/${num}/result${i}.txt,得排序文件./huan_data_rwr/random_select/rwr_result/${num}/result${i}_sorted.txt
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
        perl 9.24_random_select_filter_rwr_result_top_0.044.pl #把./huan_data_rwr/random_select/rwr_result/${num}/result${i}_sorted.txt 里面的每个文件,取top4.4%， 把筛选结果放在./huan_data_rwr/random_select/rwr_result_top_0.044/${num}/result${i}.txt
        perl 9.25_random_overlap_fact.pl #利用记录drug target 数目的文件9.21_drug_target_num.txt，把./huan_data_rwr/random_select/rwr_result_top_0.044/${num}/result${i}.txt 和08_drug_start_comma_end.txt中的end 取交集。得文件9.25_random_overlap_fact.txt
            #----------------------------------------因为多线程会存在结果不稳定的情况，所以这里把输入文件拆分，进行手动多线程在9.25_random_overlap_fact 文件夹中进行多线程并行。
            cat ./9.25_random_overlap_fact/output/9.25_random_overlap_fact*.txt > 9.25_random_overlap_fact.txt
            #----------------------------------------------------------------------------------------
        perl 9.26_count_random_overlap_fact.pl #为9.25_random_overlap_fact.txt，为每个drug对应的random_overlap_fact出现的end计数，得文件9.26_drug_count_random_overlap_fact.txt，
        #同时得end计数重复出现频率即normal score ,这个score越低，表示特异性越强，得文件9.26_drug_network_disease_gene_normal_score.txt
        perl 9.27_merge_drug_target_network_gene_normal_score.pl #把08_drug_start_comma_end.txt 中的drug target id 用../04_map_ICGC_snv_indel_in_network_num.txt 转换成entrez id，并和9.26_drug_network_disease_gene_normal_score.txt merge
        #在一起，得 9.27_merge_drug_target_network_gene_normal_score.txt

#------------------------------------------------------------------------------------
perl 10_find_logic_of_the_shortest.pl #用"/f/mulinlab/huan/All_result_ICGC/network/the_shortest_path/normal_network_num.txt"为09_the_shortest_path.txt里面的路径寻找start和end的逻辑关系,得10_start_end_logical.txt

#-------------------------------------------------------------------------
perl 11_find_cancer_for_drug.pl #利用9.27_merge_drug_target_network_gene_normal_score.txt和../04_map_ICGC_snv_indel_in_network_num.txt 和致病性的突变与癌症关系的文件"/f/mulinlab/huan/All_result_ICGC/pathogenicity_mutation_cancer/pathogenicity_mutation_cancer.txt" ，
#得与每个药物有关系的cancer文件11_ICGC_snv_indel_network_drug_cancer.txt,得没有cancer 对应的gene 文件11_no_cancer_entrez.txt
perl 12_merge_drug_indication_cancer.pl  ##利用../../all_drug_infos_score.txt和11_ICGC_snv_indel_network_drug_cancer.txt 联系起来，把drug原来的indication信息加过来，得12_ICGC_snv_indel_network_drug_indication_cancer.txt
        # #----------------------------------------------------------------判断indication和cancer 是否一致，这个判断应该再预测完再判断，这个里面的脚本mv 到了judge_drug_indication_cancer_same_script
        # perl 13_judge_network_based_somatic_repo_success.pl ##判断12_ICGC_snv_indel_network_drug_indication_cancer.txt的cancer oncotree 和indication 的oncotree是否是同一种疾病。得是同一疾病的文件13_network_based_ICGC_somatic_repo_indication_cancer_same.txt
        # #得不是同一种疾病的文件，并把不是start的drug target 过滤掉得13_network_based_ICGC_somatic_repo_indication_cancer_differ.txt,是否真的repo成功，还需要再check
        # perl 14_filter_indication_from_cancer.pl #把13_network_based_ICGC_somatic_repo_indication_cancer_differ.txt文件在indication里出现的cancer滤掉（一整行滤掉），得得文件有可能repo成功的repo drug pairs 文件14_drug_repo_cancer_pairs_may_success.txt 得drug不可以repo的cancer(是drug本来治疗的cancer)文件14_drug_repo_cancer_pairs_may_fail.txt
        # perl 15_filter_success_pair_info.pl ##把14_drug_repo_cancer_pairs_may_success.txt中的drug_repo pair从13_network_based_ICGC_somatic_repo_indication_cancer_differ.txt的全部信息（整行）筛选出来。得文件15_network_based_ICGC_somatic_repo_may_success.txt
        #-----------------------------------------------------
perl 15.1_merge_drug_target_network_id_success_pair_info.pl #用../04_map_ICGC_snv_indel_in_network_num.txt把./12_ICGC_snv_indel_network_drug_indication_cancer.txt 中的 drug entrze id 转化成在网络中的编号。得15.1_merge_drug_target_network_id_success_pair_info.txt
perl 16_merge_logic_shortest_path_cancer_gene_drug_moa_and_judge_logic.pl ##把网络最短路径的文件10_start_end_logical.txt及15.1_merge_drug_target_network_id_success_pair_info.txt merge在一起，得文件16_merge_logic_shortest_path_cancer_gene_drug_moa.txt（因为测试过中间文件很大，所以就不输出了，直接对其判断逻辑）
#并判断最短路径的逻辑和drug target 和cancer gene的逻辑，得逻辑一致的文件16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt,得逻辑不一致的文件16_judge_the_shortest_drug_target_cancer_gene_logic_conflict.txt,
#得没有逻辑的文件16_judge_the_shortest_drug_target_cancer_gene_no_logic.txt,


cat ./13_network_based_ICGC_somatic_repo_fail.txt | perl -ane 'chomp;@f= split/\t/;unless(/start_id/){print "$f[9]\t$f[-1]\n"}' | sort -u > network_based_fail_repo.txt #1902
cat network_based_fail_repo.txt | cut -f1 | sort -u > network_based_fail_drug.txt #852
