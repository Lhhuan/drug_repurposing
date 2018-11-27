cp "/f/mulinlab/huan/summary_statistics/original/UKBB_biobank/fine_mapping/paintor/Cancer/all_cancer_credible_sets_0.99_chr_pos_ref_alt.txt" ./all_cancer_credible_sets_0.99_chr_pos_ref_alt.txt
cat "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/25751625/PAINTOR/credible_sets_0.99_chr_pos_ref_alt.txt" >> all_cancer_credible_sets_0.99_chr_pos_ref_alt.txt


cp "/f/mulinlab/huan/summary_statistics/original/UKBB_biobank/fine_mapping/paintor/Cancer/all_cancer_credible_sets_0.99.txt" ./all_cancer_credible_sets_0.99.txt
cat "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/25751625/PAINTOR/all_credible_sets_0.99.txt" >> all_cancer_credible_sets_0.99.txt
#cat "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/28346442/all_credible_sets_0.99.txt" >> all_cancer_credible_sets_0.99.txt 28346442里的位点不显著

cat all_cancer_credible_sets_0.99_chr_pos_ref_alt.txt | perl -ane 'unless(/^chr/){my @f=split/\t/;my $output = join("\t",@f[0..3]);print "$output\n";} ' | sort -u > unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt.txt  #

#-------------------------------------------------------------------------------------------------------------------
#snv 和indel map 到gene逻辑：
#1 vep注释按照上游500bp,下游0bp,注释结果的biotype = protein coding 的都算map到Gene
#2 在1中没有基因的variant用enhancer target (lasso和。。)寻找variant gene
#3 在1,2中都没有gene的药物用临近基因法获得，这里的临近基因法分为两步：
# （1）用vep上下游5000bp 注释到的就算有gene,
#  (2)  在（1）中没有map到gene的variant用最近的基因作为variat的gene

perl 01_normal_vep_input_file.pl #尝试把unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt.txt处理成vep input 的输入格式，并为其定义mutation id得文件unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt.vcf # 8576281条
#用下面命令 跑多线程不知什么原因特别慢，所以在./separate1 中把unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt.vcf分成40个文件 然后对他们用 vep进行注释,脚本在./separate1/separate_the_all_ref_alt_to_40.pl   ./separate1/run.sh
##########vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt.vcf --cache --offline --plugin CADD,/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/whole_genome_SNVs.tsv.gz,/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/InDels.tsv.gz -o unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt_vep.vcf --nearest gene --fork 40  --symbol --gene --total_length --hgvs --hgvsg --protein --biotype --distance 500,0
cat ./separate1/unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt_vep*.vcf | uniq > unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt_vep.vcf  
cat unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt_vep.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\s+/;my $id = $f[0];print"$id\n";}' | sort -u > uniq_all_germline_variant_vep_ID.txt #13089057

perl 02_mutation_in_protein_coding_map_gene.pl #为unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt_vep.vcf,的mutation寻找对应的gene，此step把出现在protein coding区域的mutation对应的gene找出来，得02_mutation_in_protein_coding_map_gene.vcf,没有落在protein区域的是02_mutation_out_protein_coding_map_gene.vcf
cat 02_mutation_out_protein_coding_map_gene.vcf | perl -ane 'unless(/^#/){@f =split/\s+/;print "$f[0]\n"}' | sort -u > unique_02_out_gene.txt #7542796
cat 02_mutation_in_protein_coding_map_gene.vcf | perl -ane 'unless(/^#/){@f =split/\s+/;print "$f[0]\n"}' | sort -u > unique_02_in_gene.txt #5546261

perl 03_normal_unique_02_out_gene.txt_bed.pl #把02_mutation_out_protein_coding_map_gene.vcf转成bed文件，得03_normal_merge_all_data.bed 就是给源文件添加bed 文件需要的前三列,
cat 03_normal_merge_all_data.bed  | perl -ane 'unless(/^#/){@f =split/\t+/;print "$f[3]\n"}' | sort -u > unique_all_bed_mutationID.txt  #7542796

bedtools sort -i 03_normal_merge_all_data.bed > 03_sorted_normal_merge_all_data.bed #排序
bedtools intersect -wa -wb -a /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/enhancer–target/05_sorted_normal_merge_all_data.bed -b ./03_sorted_normal_merge_all_data.bed > 03_varaint_gene_in_enhancer_target_level2.bed  #用bedtools 为03_sorted_normal_merge_all_data.bed在"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/enhancer–target/05_sorted_normal_merge_all_data.bed"中寻找gene
perl 04_filter_mutation_out_enhancer_target.pl #把在 02_mutation_out_protein_coding_map_gene.vcf中存在，但是在03_varaint_gene_in_enhancer_target_level2.bed中不存在的突变过滤出来，得文件04_mutation_out_enhancer_target.txt #6904995
#同时把03_varaint_gene_in_enhancer_target_level2.bed输出成元vcf文件，只是在其后面追加gene的信息，得文件04_mutation_in_enhancer_target_level2.vcf 

cat 04_mutation_in_enhancer_target_level2.vcf | perl -ane 'unless(/^#/){@f =split/\s+/;print "$f[0]\n"}' | sort -u > unique_04_in_level2.txt #637801


perl 05_call_varint_out_gene_varint_enhancer_target_info.pl # 把04_mutation_out_enhancer_target.txt根据mutation_id，unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt.vcf把其他的mutation的info补齐，得文件05_out_gene_varint_enhancer_target_info.vcf
#在./separate2中把05_out_gene_varint_enhancer_target_info.vcf分成40份，然后对其进行vep注释，脚本在./separate2/separate_the_all_ref_alt_to_40.pl   ./separate2/run.sh
cat ./separate2/05_out_gene_varint_enhancer_target_info_vep*.vcf | uniq > 05_out_gene_varint_enhancer_target_info_vep.vcf
perl 06_filter_varint_gene_in_level3_1.pl #把05_out_gene_varint_enhancer_target_info_vep.vcf可以map到gene的文件筛选得临近基因法的第一个层面文件06_varint_gene_in_level3_1.vcf，得临近基因法的第二个层面文件06_varint_gene_in_level3_2.vcf
cat 06_varint_gene_in_level3_1.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\s+/;my $id = $f[0];print"$id\n";}' | sort -u > uniq_level3.1_germline_variant_gene_ID.txt #2354648
cat 06_varint_gene_in_level3_2.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\s+/;my $id = $f[0];print"$id\n";}' | sort -u > uniq_level3.2_germline_variant_gene_ID.txt #4550347


cat 02_mutation_in_protein_coding_map_gene.vcf 04_mutation_in_enhancer_target_level2.vcf 06_varint_gene_in_level3_1.vcf 06_varint_gene_in_level3_2.vcf  | uniq >all_germlie_vairant_gene.vcf 
cat all_germlie_vairant_gene.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\s+/;my $id = $f[0];print"$id\n";}' | sort -u > uniq_all_germline_variant_gene_ID.txt   #13089057

perl 07_merger_all_level_varint_gene.pl #因为检查每一层都没有丢数据，而用cat合在一起时，split查看unique 的mutation Id不对，所以，把四个数据02_mutation_in_protein_coding_map_gene.vcf, 04_mutation_in_enhancer_target_level2.vcf,06_varint_gene_in_level3_1.vcf, 06_varint_gene_in_level3_2.vcf
#读到一起，然后统一的用split分割，得all_level_germline_vairant_gene.vcf 
cat all_level_germline_vairant_gene.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\t/;my $id = $f[0];print"$id\n";}' | sort -u > uniq_all_level_germline_variant_gene_ID.txt   #13089057
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------
vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i 05_out_gene_varint_enhancer_target_info.vcf --cache --offline  -o 05_out_gene_varint_enhancer_target_info_vep.vcf --nearest gene --fork 40  --symbol --gene --total_length --hgvs --hgvsg --protein --biotype
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#此后为把mutation 和cancer连起来 

perl 08_add_mutation_id_all_cancer_credible_sets_0.99_chr_pos_ref_alt.pl #为文件all_cancer_credible_sets_0.99_chr_pos_ref_alt.txt添加mutation id的信息,得文件08_all_cancer_credible_sets_0.99_chr_pos_ref_alt_mutationID.txt