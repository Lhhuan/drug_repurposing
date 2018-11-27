wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/ChangX_28924153_GCST004885/mna_dis_ass.assoc
cp mna_dis_ass.assoc 28924153_Neuroblastoma_\(MYCN_amplification\).txt
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/ChangX_28924153_GCST004884/1p_dis_ass.assoc
cp 1p_dis_ass.assoc 28924153_Neuroblastoma_\(1p_deletion\).txt
wget  -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/ChangX_28924153_GCST004883/11q_dis_ass.assoc
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/ChangX_28924153_GCST004883/11q_rep_ass.assoc
cat 11q_dis_ass.assoc 11q_rep_ass.assoc > 11q_ass.assoc
cp 11q_ass.assoc 28924153_Neuroblastoma_\(11q_deletion\).txt