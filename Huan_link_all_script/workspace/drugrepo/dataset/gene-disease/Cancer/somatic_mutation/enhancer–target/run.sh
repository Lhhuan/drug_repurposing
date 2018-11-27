wget http://yiplab.cse.cuhk.edu.hk/jeme/encoderoadmap_lasso.zip
wget http://yiplab.cse.cuhk.edu.hk/jeme/encoderoadmap_elasticnet.zip
wget http://yiplab.cse.cuhk.edu.hk/jeme/fantom5_lasso.zip
wget http://yiplab.cse.cuhk.edu.hk/jeme/fantom5_elasticnet.zip
#把网页上的信息复制下来，存到famtom5_info.txt和ENCODE_Roadmap_info.txt里面
perl 01_merge_all_fantom5_data.pl ## 把所有的数据merge到一个文件，并在后面加上来源，得文件01_merge_all_fantom5_ENCODE_Roadmap_data.txt

perl 02_filter_ensg_NM.pl #01_merge_all_fantom5_ENCODE_Roadmap_data.txt中的gene有的以ensg表示，有的以NM表示，此处将两者分开，得02_all_ensg.txt 02_all_NM.txt
Rscript 03_trans_NM_ensg.R #把02_all_NM.txt的NMid转换成ENSGid，得文件03_NM_to_ensg.txt
perl 04_tran_NM_ensg.pl #把02_all_NM.txt和03_NM_to_ensg.txt merge 在一起，得到每个区间所对应的ensg id，得文件04_all_NM_ensg.txt 此文件里面仍然有一部分NM没有转换成ensg id

cat 02_all_ensg.txt 04_all_NM_ensg.txt  04_all_NM_ensg.txt > final_all_enhancer_target_ensg.txt
perl 04_1_filter_protein_coding_gene.pl #把final_all_enhancer_target_ensg.txt中gene_type为protein_coding的基因滤出来，得final_protein_coding_all_enhancer_target_ensg.txt

perl 05_normal_merge_all_data_bed.pl #把final_protein_coding_all_enhancer_target_ensg.txt转成bed格式，并把gene_type为protein_coding的基因滤出来，得05_normal_merge_all_data.bed
bedtools sort -i 05_normal_merge_all_data.bed >05_sorted_normal_merge_all_data.bed