perl 01_unique_cnv.pl #对../CosmicCompleteCNA.tsv.gz 进行unique，避免同一个人的同一突变多次出现而误当成occur 变大，得文件CosmicCompleteCNAunique.txt 有1024678行
perl 02_generate_GISTIC_seg_file.pl #对CosmicCompleteCNAunique.txt文件进行处理，得到GISTIC算法需要的输入，得文件GISTIC_seg_file.txt
cat GISTIC_seg_file.txt | sort -k1,1rV -k2,2rn >test.txt