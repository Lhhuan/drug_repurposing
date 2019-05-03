cp /f/mulinlab/huan/All_result_ICGC/network/network_gene_num.txt ./output/
perl 04_map_ICGC_snv_indel_to_network.pl  #把../output/11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt 和./output/network_gene_num.txt   merge ,得到icgc文件的entrez 在network 中的重叠以及在网络中的编号。
##得文件./output/04_map_ICGC_snv_indel_in_network_num.txt, #得不在网络中的gene文件，./output/04_map_ICGC_snv_indel_out_network.txt #