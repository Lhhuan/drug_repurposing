
#---------------------------------------------- mutation_map_gene_and_mutation_moa

perl 01_transform_dbNSFP_snv_to_vcf.pl #把/f/mulinlab/zhouyao/VarNoteDB/VarNoteDB_v1.0/FA/VarNoteDB_FA_dbNSFP_v3.5a/VarNoteDB_FA_dbNSFP_v3.5a.gz 转换为vep需要的vcf格式，得../output/01_dbNSFP_snv.vcf.gz


vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i ../output/01_dbNSFP_snv.vcf.gz --cache --offline -o ../output/01_dbNSFP_snv_vep.vcf --uniprot --symbol --gene --fork 30 --hgvs --hgvsg --protein --biotype
vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i ../output/01_dbNSFP_snv.vcf.gz --cache --offline -o ../output/01_dbNSFP_snv_vep_huan.vcf --fork 40 --uniprot --gene --symbol --biotype
#   /f/mulinlab/huan/tools/vep/ensembl-vep-release-93//vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i CAD_new_0511.vcf --cache --offline -o CAD_new_vep_0511.vcf --uniprot --gene --symbol --biotype

# cp /f/mulinlab/cuihui/CAD/missense_varient_predict.sh ./
# cp /f/mulinlab/cuihui/CAD/vcf_to_sift4g.py ./
# cp /f/mulinlab/cuihui/CAD/lof_variant.sh ./
ln ../output/01_dbNSFP_snv_vep_huan.vcf ./


#---------------------------------------collect cancer gene
perl 05_merge_three_source_gene.pl #将../data/cancer_gene_census.txt ../data/oncokb_cancerGeneList.txt  和cancermine_collated_and_ensg_symbol.txt merge到一起。得../output/05_three_source_gene.txt
Rscript 06_entrez_transform_ensg.R # 将../output/05_three_source_gene.txt 中的entrez转为ENSG，得../output/06_entrez_transform_ensg.txt
#因为../output/06_entrez_transform_ensg.txt中有些gene 没有找到ensg，还有55872的转换是错误的，手动对没有转成功的和转错的进行调整得../output/06_entrez_transform_ensg_refine.txt
perl 07_merge_three_source_gene_ensg.pl #将../output/05_three_source_gene.txt 和../output/06_entrez_transform_ensg.txt merge到一起得../output/07_merge_three_source_gene_ensg.txt
perl 08_filter_snv_vep_in_cancer_gene.pl #将../output/01_dbNSFP_snv_vep_huan.vcf中包含../output/07_merge_three_source_gene_ensg.txt 基因的所在行筛选出来。得./08_snv_gene_in_cancer_gene.vcf,
#得对应的missense文件是./08_snv_gene_in_cancer_gene_missense.vcf
perl 09_normal_three_source_cancer_gene.pl #将../output/07_merge_three_source_gene_ensg.txt 中的MOA进行统一的命名，得../output/09_normal_three_source_cancer_gene_source.txt,../output/09_normal_three_source_cancer_gene.txt
#得unique的cancer信息，得../output/09_unique_tumor.txt 
#将../output/09_unique_tumor.txt map 到oncotree（oncotree.mskcc.org）得../output/09_unique_tumor_oncotree.txt
perl 10_estimate_use_MOA_strict_or_loose.pl #判断../output/09_normal_three_source_cancer_gene.txt中对于特定的cancer gene moa 是loose 还是strict，得文件../output/10_unique_cancer_gene_moa_rule.txt
#对原文件../output/09_normal_three_source_cancer_gene.txt 加label得../output/10_normal_three_source_cancer_gene_lable.txt
# Strict rule: B-SFIT direction should be same with cancer type effect (oncogene, or tumor suppressor, or both, if the cancer gene moa is unique in cancer types)
# Loose rule: B-SFIT direction may not be necessarily same with cancer type effect (oncogene, or tumor suppressor, or both), but B-SFIT direction is final MOA (if the cancer gene moa are not unique in cancer types)
# Free rule: do not care about cancer types, only use B-SFIT direction in the pancancer level
#---------------------------------cancer gene in network
perl 11_transform_cancer_gene_in_network_role.pl #用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/output/network_gene_num.txt" 将../output/10_normal_three_source_cancer_gene_lable.txt中的cancer gene转换为
#在网络中的编号得../output/11_normal_three_source_cancer_gene_lable_network_id.txt, 得unique的在网络中存在的cancer gene，得../output/11_unique_network_id.txt




bash missense_varient_predict.sh
bash lof_variant.sh
