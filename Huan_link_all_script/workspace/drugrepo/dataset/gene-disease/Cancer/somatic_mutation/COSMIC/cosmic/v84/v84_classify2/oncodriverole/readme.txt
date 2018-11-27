cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/v84_classify2/3times/cosmic_all_uni_coding_path.txt"  cosmic_coding_path.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/v84_classify2/3times/Cosmic_all_ref_alt.txt" Cosmic_all_ref_alt.txt
01_connect_coding_point_to_vep.pl 把文件cosmic_coding_path.txt中的数据所对应的Cosmic_all_ref_alt.txt中的信息提出来得文件01_cosmic_coding_path_info.txt。
01_connect_coding_point_to_ID.pl 把文件cosmic_coding_path.txt中的数据所对应的Cosmic_all_ref_alt.txt中的mutation_id提出来得文件01_cosmic_coding_path_mutation_id.txt

02_filter_feature.pl 将"/CNA_cbs_logratio_GvL/01_CNA_cbs_logratio_GvL.txt"，"/MUTS_trunc_mutfreq/03_MUTS_trunc_mutfreq.txt"和 "/oncodrivecluster/04_MUTS_clusters_miss_VS_pam.txt"
三个文件mergr起来 ，获得最终用于run oncodriverule的数据。得文件02_feature_oncodriverule.
02_feature_oncodriverule文件中有一个sybmol对应两个ensg_id, 保留第一个得文件02_feature_oncodriverule_unique.txt。所有的重复基因得文件02_duplicate_txt。查看得，基本是第一个ensg_id有效。

OncodriveROLE.R 预测基因是lof 还是gof. 得文件oncodriverole_perdiction_result.txt 并在最前面加一个题头，gene_symbol

cat oncodriverole_perdiction_result.txt | perl -ane'chomp; @f = split/\t/; if ($f[3] =~/Loss/){print "$_\n"} ' > loss_of_function.txt
#
cp 02_feature_oncodriverule.txt 02_feature_oncodriverule_unique.txt
并且手动对02_feature_oncodriverule_unique.txt进行去重，仍然得文件02_feature_oncodriverule_unique.txt，
#去重的部分为文件02_duplicate_txt 
用02_feature_oncodriverule_unique.txt 预测结果为oncodriverole_perdiction_result.txt
#用02_duplicate.txt预测结果为oncodriverole_perdiction_result_1.txt


03_classify_coding_path_info.pl 将01_cosmic_coding_path_info.txt分为moa，得文件03_coding_path_moa.txt, 其他数据可以是否具有moa可以用此文件查询
得没有moa的文件03_coding_path_no_moa.txt
04_classify_coding_path_moa.pl 将文件03_coding_path_moa.txt分类，分为lof，得文件04_coding_path_lof.txt，分为gof得文件04_coding_path_gof.txt
