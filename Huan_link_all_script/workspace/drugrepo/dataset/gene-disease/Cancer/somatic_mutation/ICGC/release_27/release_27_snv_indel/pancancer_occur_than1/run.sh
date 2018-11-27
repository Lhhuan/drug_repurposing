#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#select occur time
zcat simple_somatic_mutation.aggregated.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >0){print $_}}} }' > simple_somatic_mutation.largethan0.vcf
zcat simple_somatic_mutation.aggregated.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >1){print $_}}} }' > simple_somatic_mutation.largethan1.vcf
zcat simple_somatic_mutation.aggregated.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >2){print $_}}} }' > simple_somatic_mutation.largethan2.vcf
zcat simple_somatic_mutation.aggregated.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >3){print $_}}} }' > simple_somatic_mutation.largethan3.vcf
zcat simple_somatic_mutation.aggregated.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >4){print $_}}} }' > simple_somatic_mutation.largethan4.vcf
zcat simple_somatic_mutation.aggregated.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >5){print $_}}} }' > simple_somatic_mutation.largethan5.vcf

wc -l simple_somatic_mutation.largethan0.vcf #77462290
wc -l simple_somatic_mutation.largethan1.vcf #6335312
wc -l simple_somatic_mutation.largethan2.vcf #1512015
wc -l simple_somatic_mutation.largethan3.vcf #626963
wc -l simple_somatic_mutation.largethan4.vcf #334462
wc -l simple_somatic_mutation.largethan5.vcf #194031
Rscript select_occur.R  #绘制不同occurthanX与mutation 数目的关系。


wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_28/GRCh37_mapping/gencode.v28lift37.annotation.gff3.gz
gzip -d gencode.v28lift37.annotation.gff3.gz #得gencode.v28lift37.annotation.gff3
wget -c ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gff3.gz
gzip -d gencode.v19.annotation.gff3.gz #得文件gencode.v19.annotation.gff3


perl collect_protein_coding_gene.pl #把gencode.v19.annotation.gff3中gene_type为protein_coding的gene筛选出来。得文件protein_coding_gene.txt #20327 个protein_coding

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 #map indel and snv to gene 

vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i simple_somatic_mutation.largethan1.vcf --cache --offline --plugin CADD,whole_genome_SNVs.tsv.gz,InDels.tsv.gz -o simple_somatic_mutation.largethan1_vep.vcf --nearest gene --fork 40  --symbol --gene --total_length --hgvs --hgvsg --protein --biotype --distance 500,0
cat simple_somatic_mutation.largethan1_vep.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\s+/;my $id = $f[0];print"$id\n";}' | sort -u > uniq_somatic_snv_indel_vep.txt  #6335265


#./sorted/VannoDB_DA_ICGC_r27_snp.vcf.gz 是whole_genome_SNVs.tsv.gz排序后的结果

#snv 和indel map 到gene逻辑：map到的所以gene为protein_coding
#1 vep注释按照上游500bp,下游0bp,注释结果的biotype = protein coding 的都算map到Gene
#2 在1中没有基因的variant用enhancer target (lasso和。。)寻找variant gene
#3 在1,2中都没有gene的药物用临近基因法获得，这里的临近基因法分为两步：
# （1）用vep上下游5000bp 注释到的就算有gene,
#  (2)  在（1）中没有map到gene的variant用最近的基因作为variat的gene
perl 01_mutation_in_protein_coding_map_gene.pl  #为simple_somatic_mutation.largethan1_vep.vcf的mutation寻找对应的gene，此step把出现在protein coding区域的mutation对应的gene找出来，得01_mutation_in_protein_coding_map_gene.vcf,没有落在protein区域的是01_mutation_out_protein_coding_map_gene.vcf #4747159
cat 01_mutation_out_protein_coding_map_gene.vcf | perl -ane 'unless(/^#/){@f =split/\s+/;print "$f[0]\t$f[1]\n"}' | sort -u > unique_01_out_gene.txt #
cat 01_mutation_in_protein_coding_map_gene.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\s+/;my $id = $f[0];print"$id\n";}' | sort -u > unique_01_in_gene1.txt #
cat 01_mutation_out_protein_coding_map_gene.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\s+/;my $id = $f[0];print"$id\n";}' | sort -u > unique_01_out_gene1.txt  #
perl 02_normal_unique_01_out_gene_varint_bed.pl #把01_mutation_out_protein_coding_map_gene.vcf转成bed文件，得02_normal_unique_01_out_gene_varint.bed 就是给源文件添加bed 文件需要的前三列,

bedtools sort -i 02_normal_unique_01_out_gene_varint.bed > 02_sorted_final_normal_unique_01_out_gene_varint.bed #排序
bedtools intersect -wa -wb -a ../../../enhancer–target/05_sorted_normal_merge_all_data.bed -b ./02_sorted_final_normal_unique_01_out_gene_varint.bed > 02_connect_out_gene_varint_enhancer_target.bed  #用bedtools 为02_sorted_final_normal_unique_01_out_gene_varint.bed在../../../enhancer–target/05_sorted_normal_merge_all_data.bed中寻找gene
perl 03_filter_mutation_out_enhancer_target.pl #把在01_mutation_out_protein_coding_map_gene.vcf中存在，但是在02_connect_out_gene_varint_enhancer_target.bed中不存在的突变过滤出来，得文件03_mutation_out_enhancer_target.vcf, #3758803
#同时把02_connect_out_gene_varint_enhancer_target.bed输出成元vcf文件，只是在其后面追加gene的信息，得文件03_mutation_in_enhancer_target.vcf



perl 04_call_varint_out_gene_varint_enhancer_target_info.pl # 把03_mutation_out_enhancer_target.vcf根据mutation_id，simple_somatic_mutation.largethan1.vcf把其他的mutation的info补齐，得文件04_out_gene_varint_enhancer_target_info.vcf #
#在./separate1中把04_out_gene_varint_enhancer_target_info.vcf分成40份，然后对其进行vep注释，脚本在./separate1/separate_the_all_ref_alt_to_40.pl   ./separate1/run.sh
cat ./separate1/04_out_gene_varint_enhancer_target_info_vep*.vcf | uniq > 04_out_gene_varint_enhancer_target_info_vep.vcf
#vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i 04_out_gene_varint_enhancer_target_info.vcf --cache --offline  -o 04_out_gene_varint_enhancer_target_info_vep.vcf --nearest gene --fork 40  --symbol --gene --total_length --hgvs --hgvsg --protein --biotype 

perl 05_filter_varint_gene_in_level3.pl #把04_out_gene_varint_enhancer_target_info_vep.vcf可以map到gene的文件筛选得临近基因法的第一个层面文件05_varint_gene_in_level3_1.vcf，得临近基因法的第二个层面的mutation，05_varint_out_level3_1.vcf

cat 05_varint_gene_in_level3_1.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\s+/;my $id = $f[0];print"$id\n";}' | sort -u > uniq_somatic_level3.1_ID.txt #
wc -l  05_varint_out_level3_1.vcf # 3606131
perl 06_call_variant_out_level3_1.pl #把05_varint_out_level3_1.vcf根据mutation_id，simple_somatic_mutation.largethan1.vcf把其他的mutation的info补齐，得文件06_varint_out_level3_1_info.vcf
perl 061_trans_varint_out_level3_1_info_bed.pl  #把06_varint_out_level3_1_info.vcf转为bed 格式，即给06_varint_out_level3_1_info.vcf文件加一列，得06_varint_out_level3_1_info.bed
bedtools sort -i 06_varint_out_level3_1_info.bed > 06_sorted_varint_out_level3_1_info.bed

perl 062_filter_protein_coding_gene.pl   #把gencode.v19.annotation.gff3的protein_coding 区域的基因筛选出来,得gencode.v19.protein_coding.bed #20327 个
cat gencode.v19.protein_coding.bed | sort -k1,1 -k2,2n >sorted_gencode.v19.protein_coding.bed
bedtools closest -a 06_sorted_varint_out_level3_1_info.bed -b  sorted_gencode.v19.protein_coding.bed |sort -u > find_level_3.2_closest.bed # 
cat find_level_3.2_closest.bed | cut -f4 |uniq| wc -l #3606131
perl 063_normal_mutation_to_gene_level3_2.pl #利用04_out_gene_varint_enhancer_target_info_vep.vcf 把find_level_3.2_closest.bed normal成和上面一样的文件，得063_normalized_mutation_to_gene_level3_2.txt # 3611848

perl 06_merger_all_level_varint_gene.pl #把四个数据01_mutation_in_protein_coding_map_gene.vcf, 03_mutation_in_enhancer_target.vcf,05_varint_gene_in_level3_1.vcf, 063_normalized_mutation_to_gene_level3_2.txt
#读到一起，然后统一的用split分割，得all_level_somatic_snv_indel_gene.vcf 
cat all_level_somatic_snv_indel_gene.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\t/;my $id = $f[0];print"$id\n";}' | sort -u > uniq_all_level_somatic_snv_indel_gene_ID.txt  #6335265
cat all_level_somatic_snv_indel_gene.vcf | perl -ane 'chomp;unless(/^#/){@f = split/\t/;my $id = $f[3];print"$id\n";}' | sort -u >uniq_all_level_cancer_gene.txt #20216个
perl test.pl #测试uniq_all_level_cancer_gene.txt比gencode.v19.protein_coding.bed多出来的gene 得test_protein_coding.txt

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

###perl 02_mutaion_out_protein_coding_map_gene_enhancer_target.pl #为unique_01_out_gene.txt在"../../../enhancer–target/01_merge_all_fantom5_ENCODE_Roadmap_data.txt" 寻找gene，得可以map上的文件02_mutation_in_enhancer–target_gene.vcf,得map不上的文件02_mutation_out_enhancer–target_gene.vcf
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
perl 07_cut_all_level_somatic_snv_indel_gene.pl #提取文件all_level_somatic_snv_indel_gene.vcf的mutation id,gene及genelevel得文件07_somatic_snv_indel_mutationID_gene_geneLevel.txt
Rscript 08_transform_07_ensg_entrezid.R #把07_somatic_snv_indel_mutationID_gene_geneLevel.txt的ensgid 转成entrezID,得文件08_ensg_to_entrezid.txt
perl 09_merge_ensg_info_entrezid.pl #把07_somatic_snv_indel_mutationID_gene_geneLevel.txt 和 08_ensg_to_entrezid.txt merge在一起得文件09_somatic_snv_indel_mutationID_ensg_entrez.txt
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



wget -c http://krishna.gs.washington.edu/download/CADD/v1.4/GRCh37/InDels.tsv.gz
wget -c http://krishna.gs.washington.edu/download/CADD/v1.4/GRCh37/InDels.tsv.gz.tbi
wget -c http://krishna.gs.washington.edu/download/CADD/v1.4/GRCh37/whole_genome_SNVs.tsv.gz
wget -c http://krishna.gs.washington.edu/download/CADD/v1.4/GRCh37/whole_genome_SNVs.tsv.gz.tbi



#用vep注释snv行不通
./sorted/VannoDB_DA_ICGC_r27_snp.vcf.gz 是whole_genome_SNVs.tsv.gz排序后的结果


cat "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/01_mutation_in_protein_coding_map_gene.vcf" | perl -ane 'chomp; unless(/^#/){print "$F[0]\n";}' | sort -u > uniqu_protein_coding.txt #2518755  #2346449
cat 01_mutation_out_protein_coding_map_gene.vcf | perl -ane 'chomp; unless(/^#/){print "$F[0]\n";}' | sort -u > uniqu_no_protein_coding.txt #3816510

cat simple_somatic_mutation.largethan1.vcf | perl -ane 'chomp; unless(/^#/){print "$F[2]\n";}' | sort -u > all_uniqu_morethan1_vid.txt #6335312
cat simple_somatic_mutation.largethan1_vep.vcf | perl -ane 'chomp; unless(/^#/){print "$F[0]\n";}' | sort -u > all_vep_uniqu_morethan1_vid.txt  #6335265  #等于step1的结果相加数目
cat simple_somatic_mutation.largethan1_vep.vcf | perl -ane 'chomp; unless(/^#/){my @info_array = split(/;/,$F[13]); foreach my $i (@info_array){if($i =~ /^BIOTYPE/){print "$i\n";}}}' | sort -u > unique_biotype.txt

