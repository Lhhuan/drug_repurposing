cat "/f/mulinlab/huan/hongcheng/script/01_dbNSFP_snv_vep_huan.vcf" | head -1000 > test.vcf
cat "/f/mulinlab/huan/hongcheng/script/01_dbNSFP_snv_vep_huan.vcf" | sed -n '10000,11000p' >> test.vcf
cat "/f/mulinlab/huan/hongcheng/script/01_dbNSFP_snv_vep_huan.vcf" | tail -1000 >> test.vcf
bash missense_varient_predict.sh
bash lof_variant.sh

perl 01_merge_missense_and_lof_moa.pl #将./B_sift_tmp/missense_match_bscore.txt 中的LOF 和GOF 区分出来，并和./B_sift_tmp/varient_lof.txt merge 到一起，得./output/01_merge_missense_and_lof_vraint_moa.txt
