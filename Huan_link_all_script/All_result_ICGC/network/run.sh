cp "/f/mulinlab/huan/All_result/normal_network.txt" normal_network.txt #这个 #z找最短路径的时候用这个网络
cat normal_network.txt | perl -ane 'chomp;unless(/^id1/){@f=split/\t/;print"$f[0]\n$f[1]\n"}' | sort -u  > network_gene.txt #网络中所有gene的unique  
Rscript network_gene_to_entrezid.R #把network_gene.txt的gene symbol转成entrezid得文件network_symbol_to_entrez.txt；
perl supple_no_entrezid.pl #network_symbol_to_entrez.txt中不包括network_gene.txt中的全部基因，没有entrez的基因用symbol代替。得文件all_network_symbol_to_entrez.txt
perl network_gene_num.pl ##给all_network_symbol_to_ensg.txt 的gene进行编号,得文件network_gene_num.txt 
perl map_original_network_gene_id.pl ##将FIsInGene_022717_with_annotations.txt的gene换成id。。 这个是训练nb_lin.m所需要的文件original_network_num.txt。  ##这个用于本地网络的输入

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#prepare rwr end

perl 04_map_ICGC_snv_indel_to_network.pl  #把../11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt 和network_gene_num.txt   merge ,得到icgc文件的entrez 在network 中的重叠以及在网络中的编号。
##得文件04_map_ICGC_snv_indel_in_network_num.txt, #得不在网络中的gene文件，04_map_ICGC_snv_indel_out_network.txt #


#---------------------------------------------------------------------------------------------------------------------------------------------------------
# Rscript network_gene_to_ensgid.R #把network_gene.txt的gene symbol转成ensgid得文件network_symbol_to_ensg.txt；
# perl supple_no_ensgid.pl ##network_symbol_to_ensg.txt中不包括network_gene.txt中的全部基因，没有ensg的基因用symbol代替。得文件all_network_symbol_to_ensg.txt

# perl map_start_drug_target_num.pl #将unique_drug_target_symbol_Entrez_id.txt的gene_symbol和entrezgene换成id，得在本底网络中有的基因文件start_drug_target_network_num.txt，共2675个基因，得在本底网络中没有的基因文件no_start_drug_target_network_num.txt，共487个基因。
# cat start_drug_target_network_num.txt | perl -ane 'chomp;@f=split/\t/;unless(/^gene_symbol/){print"$f[2]\n";}' | sort -u > start_drug_target_network_num_final.txt #做为rwr的start。此文件用于随机游走的start


# perl map_somatic_entrez_num.pl #为文件somatic_uni_entrez.txt寻找在network_gene_num.txt中的编号。在网络中存在的基因的文件somatic_uni_entrez_num.txt 共3831个，在得在本底网络中没有的基因文件no_somatic_uni_entrez_num.txt，共2110个。



#####cp "/f/mulinlab/huan/All_result/FIsInGene_022717_with_annotations.txt"  FIsInGene_022717_with_annotations.txt  #将没有处理过的原网络数据copy


# cat "/f/mulinlab/huan/All_result/huan_target_drug_indication_final_symbol.txt" | perl -ane 'chomp; unless(/^Drug/){@f= split/\t/;print "$f[2]\t$f[-3]\n";}' | sort -u >unique_drug_target_symbol_ensg_id.txt # 得到huan_target_drug_indication_final_symbol.txt的unique的gene symbol ,ensg, 即得到unique的drug_target的gene symbol,ensg
# perl map_start_drug_target_num.pl #将unique_drug_target_symbol_ensg_id.txt的gene_symbol和ensg换成id，得在本底网络中有的基因文件start_drug_target_network_num.txt，共2675个基因，得在本底网络中没有的基因文件no_start_drug_target_network_num.txt，共487个基因。





# perl prapare_metis.pl #将文件normal_network_num.txt的前后节点交换后去重输出为metis可以用的格式做准备。得original_network_num_metis.txt
# cat original_network_num_metis.txt| sort -t $'\t' -k1,1n | perl -ane 'chomp; @f= split/\t/;$k = join ("\t",@f[1..$#f]); print"$k\n"; ' > original_network_metis_input.txt
# #对normal_network_num_metis.txt的第一列进行排序（因为要按照开始节点的顺序进行排列），然后把第一列去掉。得文件 original_network_metis_input.txt,并手动#为 original_network_metis_input.txt 手动在最前面添加12277    230243  001中间以tab分割。#230243为文件FIsInGene_022717_with_annotations.txt除header外的行数。
# /f/mulinlab/huan/tools/metis-5.1.0/bin/gpmetis original_network_metis_input.txt 100  #对original_network_metis_input.txt进行分割，分成100份，得文件original_network_metis_input.txt.part.100
# cp "/f/mulinlab/huan/All_result/unique_drug_target_symbol_Entrez_id.txt"  unique_drug_target_symbol_Entrez_id.txt
# perl map_start_drug_target_num.pl #将unique_drug_target_symbol_Entrez_id.txt的gene_symbol和entrezgene换成id，得在本底网络中有的基因文件start_drug_target_network_num.txt，共2675个基因，得在本底网络中没有的基因文件no_start_drug_target_network_num.txt，共487个基因。
# cat start_drug_target_network_num.txt | perl -ane 'chomp;@f=split/\t/;unless(/^gene_symbol/){print"$f[2]\n";}' | sort -u > start_drug_target_network_num_final.txt #做为rwr的start。此文件用于随机游走的start

# #w2.txt为normal_network_num.txt标准化后的结果，具体脚本见本地matlab脚本E:\桌面\drug repositioning new\drug repositioning\drug repositioning\network\random walk\drugresponse\scripts\nb_lin.m  
# #w2.txt 的存储脚本见本地matlab脚本E:\桌面\drug repositioning new\drug repositioning\drug repositioning\network\random walk\drugresponse\scripts\W2_to_partition_file.m
# perl prapare_W2_metis.pl
# cat w2_metis.txt| sort -t $'\t' -k1,1n | perl -ane 'chomp; @f= split/\t/;$k = join ("\t",@f[1..$#f]); print"$k\n"; ' > w2_metis_input.txt
# #对w2_metis.txt的第一列进行排序（因为要按照开始节点的顺序进行排列），然后把第一列去掉。得文件 w2_metis_input.txt,并手动#为 w2_metis_input.txt 手动在最前面添加12277    230243  001中间以tab分割
# /f/mulinlab/huan/tools/metis-5.1.0/bin/gpmetis w2_metis_input.txt 100 
# #这里的脚本意义同上,得w2_metis_input.txt.part.100



# # cp "/f/mulinlab/huan/All_result/uni_network_start.txt"  uni_network_start.txt  #有8675行，即有8674(都准换成大写后,有一个重复，所以总数少了一个)个基因。
# # perl map_start_gene_num.pl #将uni_network_start.txt的gene换成id，得在本底网络中有的基因文件start_network_num.txt，共3917个基因，得在本底网络中没有的基因文件no_start_network_num.txt，共4757个基因。

# #cosmic经过我们的条件筛选后， 一共有8674(coding+noncoding)个gene symbol，有3917在FI中，有4757不在FI中，也就是说，我们只能对3917在FI中的基因进行RMR gene_disease


# # perl make_drug_target_vector.pl #把start_drug_target_network_num.txt生成作为RMR start 的文件 drug_target_start.txt
# # cat drug_target_start.txt | sort -t $'\t' -k1,1n | perl -ane 'chomp; @f = split /\t/; print "$f[1]\n";'> final_drug_target_vector.txt #生成按节点排序的vector
# # cat network_gene_num.txt | perl -ane 'chomp; unless(/^gene/){@f = split/\t/;print "$f[1]\n";}' > gene_list.txt #生成gene_list.txt用作rwr_huan.php所需文件

# # perl map_network_gene_id_weight_1.pl ##将normal_network.txt的gene换成id,并把文件所以有的weight设置成1，得文件normal_network_num_weight_1.txt 得


