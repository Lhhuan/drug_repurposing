#有多少个project 出现，就是多少个人，比如：A,A,D,B。就是有4个人在这个hotspot 出现过，也就是hotspot 的occurance 是4
perl 01_refine_tra.pl  #因为./v4/SV/TRA_hotspot_score 中有两条重复的记录，但他们的project 不相同。把他们的project 合并得./v4/SV/refine_TRA_hotspot_score
cat ./v4/CNV/AMP_hotspot_score > ./v4/CNV/All_CNV_hotspot_score
cat ./v4/CNV/cnLOH_hotspot_score |awk 'NR>1' >> ./v4/CNV/All_CNV_hotspot_score
cat ./v4/CNV/DEL_hotspot_score |awk 'NR>1' >> ./v4/CNV/All_CNV_hotspot_score
cat ./v4/CNV/LOH_hotspot_score |awk 'NR>1' >> ./v4/CNV/All_CNV_hotspot_score
cat ./v4/CNV/LOHgain_hotspot_score |awk 'NR>1' >> ./v4/CNV/All_CNV_hotspot_score
perl 02_merge_SV_cnv.pl # #将./v4/SV/refine_TRA_hotspot_score， ./v4/SV/DEL_hotspot_score, ./v4/SV/DUP_hotspot_score, ./v4/SV/INV_hotspot_score, ./v4/CNV/All_CNV_hotspot_score merge到一起，得./v4/output/all_sv_snv.vcf
perl 03_count_sv_cnv_number.pl #