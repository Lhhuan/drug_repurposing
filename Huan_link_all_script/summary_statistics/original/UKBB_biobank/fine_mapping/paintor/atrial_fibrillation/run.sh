##---------------------------------------------fine mapping
#perl batch_prepare_paintor.pl  #run paintor

#-----------------------------------------------------select 0.99
perl 02_get_credible_sets_0.99.pl #取每个文件的top0.99
perl 03_merge_all_credible_sets_0.99.pl # 把每个文件的top0.99merge 成一个文件。
cat all_cancer_credible_sets_0.95_chr_pos_ref_alt.txt | cut -f1,2,3,4 | sort -u |sort -k1,1Vr > unique_all_cancer_credible_sets_0.95_chr_pos_ref_alt.txt
#-------------------------------------------------------------------------- mutation map to gene
perl 04_normal_vep_input_file.pl #normalized成vep注释可以用的文件unique_all_cancer_credible_sets_0.95_chr_pos_ref_alt.vcf
vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i unique_all_cancer_credible_sets_0.95_chr_pos_ref_alt.vcf --cache --offline  -o unique_all_cancer_credible_sets_0.95_chr_pos_ref_alt_vep.vcf --nearest gene  --symbol --gene --total_length --hgvs --hgvsg --protein --biotype --distance 500,0
perl 05_mutation_in_protein_coding_map_gene.pl #500,0 map to proteincoding 
perl 06_normal_unique_05_out_gene_varint_bed.pl #把05_mutation_out_protein_coding_map_gene.vcf转成bed文件，得06_normal_unique_05_out_gene_varint.bed 就是给源文件添加bed 文件需要的前三列,
bedtools sort -i 06_normal_unique_05_out_gene_varint.bed > 06_sorted_final_normal_unique_05_out_gene_varint.bed #排序
bedtools intersect -wa -wb -a "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/enhancer–target/05_sorted_normal_merge_all_data.bed" -b ./06_sorted_final_normal_unique_05_out_gene_varint.bed > 06_connect_out_gene_varint_enhancer_target.bed #用bedtools 为06_sorted_final_normal_unique_05_out_gene_varint.bed在05_sorted_normal_merge_all_data.bed中寻找gene
perl 07_filter_mutation_out_enhancer_target.pl #把在05_mutation_out_protein_coding_map_gene.vcf中存在，但是在06_connect_out_gene_varint_enhancer_target.bed中不存在的突变过滤出来，得文件07_mutation_out_enhancer_target.txt, 
#同时把06_connect_out_gene_varint_enhancer_target.bed输出成元vcf文件，只是在其后面追加gene的信息，得文件07_mutation_in_enhancer_target_level2.vcf
perl 08_call_varint_out_gene_varint_enhancer_target_info.pl ## 把07_mutation_out_enhancer_target.txt根据mutation_id，unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt.vcf把其他的mutation的info补齐，得文件08_out_gene_varint_enhancer_target_info.vcf
vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i 08_out_gene_varint_enhancer_target_info.vcf --cache --offline  -o 08_out_gene_varint_enhancer_target_info_vep.vcf --nearest gene --symbol --gene --total_length --hgvs --hgvsg --protein --biotype 
perl 09_filter_varint_gene_in_level3.pl  #把08_out_gene_varint_enhancer_target_info_vep.vcf可以map到gene的文件筛选得临近基因法的第一个层面文件09_varint_gene_in_level3_1.vcf，得临近基因法的第二个层面文件09_varint_gene_in_level3_2.vcf
perl 10_merger_all_level_varint_gene.pl  #把四个数据05_mutation_in_protein_coding_map_gene.vcf, 07_mutation_in_enhancer_target_level2.vcf,09_varint_gene_in_level3_1.vcf, 09_varint_gene_in_level3_2.vcf#读到一起，然后统一的用split分割，得all_level_germlie_vairant_gene.vcf 

cat all_level_germline_vairant_gene.vcf | perl -ane 'chomp;my @f =split/\t/;unless(/^#/){print "$f[3]\t$f[14]\n"}' | sort -u >atrial_fibrillation_related_gene.txt
cat all_level_germline_vairant_gene.vcf | perl -ane 'chomp;my @f =split/\t/;unless(/^#/){print "$f[0]\n"}' | sort -u >atrial_fibrillation_related_mutation.txt


grep -w "IBRUTINIB" "/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" > IBRUTINIB.txt
grep -w "TRASTUZUMAB" "/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" >TRASTUZUMAB.txt
grep -w "CISPLATIN" "/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" >CISPLATIN.txt
grep -w "GEMCITABINE" "/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" >GEMCITABINE.txt
grep -w "FLUOROURACIL" "/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" >FLUOROURACIL.txt 
grep -w "DOXORUBICIN" "/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" >DOXORUBICIN.txt
cat IBRUTINIB.txt TRASTUZUMAB.txt CISPLATIN.txt GEMCITABINE.txt FLUOROURACIL.txt DOXORUBICIN.txt >all_drug_info.txt
cat all_drug_info.txt | cut -f3,5,7,8,20 |sort -u |sort -k4,4V >drug_target_info.txt #symbol,entrez_id,moa,drug,ensg_id


perl 11_overlap_gene_drug_target.pl #判断atrial_fibrillation_related_gene.txt 是否在drug_target_info.txt，得在的文件11_atrial_fibrillation_drug_target_info.txt