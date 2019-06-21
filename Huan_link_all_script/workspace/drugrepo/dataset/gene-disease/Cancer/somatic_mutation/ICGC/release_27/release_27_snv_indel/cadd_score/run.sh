# ##用最后一列数据MEANPHRED进行过滤，cutoff为>=15, 参考https://cadd.gs.washington.edu/info
# # cat insertion_cadd_score deletion_cadd_score snp_cadd_score > SNV_Indel_cadd_score.vcf
# # cat SNV_Indel_cadd_score.vcf | cut -f3,10 >SNV_Indel_cadd_score_simple.txt
# cp /f/mulinlab/zhouyao/workspace/huan/results/cadd_score/cadd_phred_score/* ./


# # cat insertion_cadd_score | cut -f3,11 >before_SNV_Indel_cadd_score_simple.txt
# # cat deletion_cadd_score | cut -f3,11 >>before_SNV_Indel_cadd_score_simple.txt
# # cat snp_cadd_score | cut -f3,11 >>before_SNV_Indel_cadd_score_simple.txt



# perl 01_merge_pos_variant_id.pl #用../simple_somatic_mutation.largethan0.vcf 为snp_add_cadd_score 添加mutation id, 得文件./snv_cadd_score_mutation_id.txt

# cat insertion_cadd_score | cut -f3,11 >SNV_Indel_cadd_score_simple.txt
# cat deletion_cadd_score | cut -f3,11 >>SNV_Indel_cadd_score_simple.txt
# cat snv_cadd_score_mutation_id.txt | awk 'NR>1'| cut -f1,9 >>SNV_Indel_cadd_score_simple.txt

cp  -r /f/mulinlab/zhouyao/workspace/huan/results/cadd_score/cadd_phred_score_v2/ ./
cp /f/mulinlab/zhouyao/workspace/huan/results/cadd_score/cadd_phred_score_v2/* ./


cat cadd_phred_score_v2/snp_cadd_score_v2  | cut -f1,2,3,4,5,8 > SNV_Indel_cadd_score_simple.txt
cat cadd_phred_score_v2/deletion_cadd_score_v2 |awk 'NR>1'| cut -f1,2,3,5,6,11 >>SNV_Indel_cadd_score_simple.txt
cat cadd_phred_score_v2/insertion_cadd_score_v2 |awk 'NR>1'| cut -f1,2,3,5,6,12 >>SNV_Indel_cadd_score_simple.txt