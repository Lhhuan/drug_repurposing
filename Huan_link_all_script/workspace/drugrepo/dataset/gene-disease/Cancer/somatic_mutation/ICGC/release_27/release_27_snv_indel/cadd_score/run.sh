##用最后一列数据MEANPHRED进行过滤，cutoff为>=15, 参考https://cadd.gs.washington.edu/info
cat insertion_cadd_score deletion_cadd_score snp_cadd_score > SNV_Indel_cadd_score.vcf
cat SNV_Indel_cadd_score.vcf | cut -f3,10 >SNV_Indel_cadd_score_simple.txt