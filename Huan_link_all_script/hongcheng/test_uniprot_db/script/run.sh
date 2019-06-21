perl 01_filter_missense_protein.pl ##将"/f/mulinlab/huan/hongcheng/script/08_snv_gene_in_cancer_gene_missense.vcf" 中的protein 提取出来得../output/01_filter_missense_protein.txt
perl 02_filter_not_in_uniparc.pl #筛选出不在../output/01_filter_missense_protein.txt 的"/f/mulinlab/huan/hongcheng/uniprot_db/uniparc.gz"，得../output/02_filter_no_in_uniparc.txt
perl 03_filter_not_in_uniprotkb_swissprot.pl #筛选出不在../output/01_filter_missense_protein.txt 的"/f/mulinlab/huan/hongcheng/uniprot_db/uniprotkb_swissprot.gz"，得../output/03_filter_no_in_uniprotkb_swissprot.txt
perl 04_filter_not_in_uniprotkb_trembl.pl #筛选出不在../output/01_filter_missense_protein.txt 的"/f/mulinlab/huan/hongcheng/uniprot_db/uniprotkb_trembl.gz"，得../output/04_filter_no_in_uniprotkb_trembl.txt
perl 05_filter_not_in_uniref90.pl #筛选出不在../output/01_filter_missense_protein.txt 的"/f/mulinlab/huan/hongcheng/uniprot_db/uniref90.gz"，得../output/05_filter_no_in_uniref90.txt
perl 06_filter_in_uniparc.pl #将../output/02_filter_in_uniparc.txt中的ID 从"/f/mulinlab/huan/hongcheng/uniprot_db/uniparc.gz" 中提取出来，得../output/06_used_to_build_db_uniparc.txt
perl 07_filter_uniparc_out_and_random_select.pl #将ID不在../output/02_filter_in_uniparc.txt中的"/f/mulinlab/huan/hongcheng/uniprot_db/uniparc.gz",随机选160000行出来，得../output/07_random_select_uniparc.txt
perl 08_filter_uniparc_in_random.pl #将在../output/07_random_select_uniparc.txt 中的"/f/mulinlab/huan/hongcheng/uniprot_db/uniparc.gz"内容调出来，得../output/08_filter_uniparc_in_random.txt

cat ../output/06_used_to_build_db_uniparc.txt ../output/08_filter_uniparc_in_random.txt > ../output/In_db_and_random_uniparc.txt



grep ">" "/f/mulinlab/huan/hongcheng/uniprot_db/uniprotkb_swissprot" | grep "OX=9606" >../output/swissprot_homo.txt

perl 09_filter_homo_in_swissprot.pl #将在../output/swissprot_homo.txt 中的"/f/mulinlab/huan/hongcheng/uniprot_db/uniprotkb_swissprot"内容调出来，得../output/09_filter_homo_in_swissprot.txt

cat ../output/06_used_to_build_db_uniparc.txt  ../output/09_filter_homo_in_swissprot.txt >../output/In_db_uniparc_and_homo_in_swissprot.txt
