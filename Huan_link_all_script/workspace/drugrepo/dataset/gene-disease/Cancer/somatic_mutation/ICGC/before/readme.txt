# cp -r "/f/mulinlab/ref_data/ICGC/"  ICGC_FM
# cp -r "/f/mulinlab/ref_data/ICGC/"  ICGC_REPAIR   里面是修复后的文件。

# 1 wget  https://dcc.icgc.org/api/v1/download?fn=/current/Summary/simple_somatic_mutation.aggregated.vcf.gz 
# 2 cp download?fn=%2Fcurrent%2FSummary%2Fsimple_somatic_mutation.aggregated.vcf.gz  simple_somatic_mutation.aggregated.vcf.gz
# 3 ./bin/convert2bed -i vcf  < simple_somatic_mutation.aggregated.vcf > somatic.vcf.bed   # vcf 转bed
# 4 01_get_from_vcf.pl : 解析文件somatic.vcf.bed 得文件01_somatic.vcf用于vep注释得文件01_somatic_disease_occur.txt 包含体细胞突变的频率及导致的疾病。 
# 5 01_somatic.vcf用在http://grch37.ensembl.org/Homo_sapiens/Tools/VEP网站进行注释，


# /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/01_somatic.vcf  -o /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/anno_out.txt --cache --offline --fork 4  --symbol >nohup.out

# /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/somatic.vcf  -o anno.out --cache --offline 

# /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  small.vcf  -o anno.vcf --cache --offline --fork 4  

# /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  small.vcf  -o anno.out --cache --offline --fork 4  --symbol


# /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  ./ICGC_REPAIR/release_26/simple_somatic_mutation.largethan1.nm.vcf  -o simple_somatic_mutation.largethan1.nm.vep.vcf --cache --offline --fork 4  --symbol  


1 wget  https://dcc.icgc.org/api/v1/download?fn=/current/Summary/simple_somatic_mutation.aggregated.vcf.gz 
2 cp download?fn=%2Fcurrent%2FSummary%2Fsimple_somatic_mutation.aggregated.vcf.gz  simple_somatic_mutation.aggregated.vcf.gz
3 用 bcftools将simple_somatic_mutation.aggregated.vcf.gz对齐得"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/ICGC_REPAIR/release_26/simple_somatic_mutation.aggregated.norm.snp.vcf.gz"
4 zcat simple_somatic_mutation.aggregated.norm.vcf.gz |perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >1){print $_}}} }' > simple_somatic_mutation.largethan2.vcf
文件simple_somatic_mutation.aggregated.norm.vcf.gz中affected_donors大于1得文件simple_somatic_mutation.largethan1.vcf 
5 因为文件 simple_somatic_mutation.largethan1.vcf 里的 alt allele 有. 所以程序到这里就中断，所以把alt allele 为.的都去掉得到文件simple_somatic_mutation.largethan1.nm.vcf ，用此文件进行vep注释。

nohup  /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  ./ICGC_REPAIR/release_26/simple_somatic_mutation.largethan1.nm.vcf  -o simple_somatic_mutation.largethan1.nm.vep.vcf --cache --offline --fork 24  --symbol > nohup.out &

6 01_classify_largethen1_vep.pl  将simple_somatic_mutation.largethan1.nm.vep.vcf分为编码区和非编码区。 
       得非编码区文件 simple_somatic_mutation_largethan1_nm_vep_noncoding.txt
       得编码区文件simple_somatic_mutation_largethan1_nm_vep_coding.txt
 因为如果一个variant只要hit到coding里面的一个，就算coding，所以对非编码区文件 simple_somatic_mutation_largethan1_nm_vep_noncoding.txt进行进一步的划分，剔除simple_somatic_mutation_largethan1_nm_vep_noncoding.txt中
 在simple_somatic_mutation_largethan1_nm_vep_coding.txt中出现的variant 得只在simple_somatic_mutation_largethan1_nm_vep_noncoding.txt中出现的variant 得文件simple_somatic_mutation_largethan1_nm_vep_true_noncoding.txt
   
7 02_connect_classify_vcf.pl 将simple_somatic_mutation_largethan1_nm_vep_coding.txt补全ref allele,disease(从文件simple_somatic_mutation_largethan1_nm_vep_coding.txt中获取数据) 得文件simple_somatic_mutation_largethan1_nm_vep_coding_disease.txt

8 "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/REVEL/coding_revel_score.pl" 为simple_somatic_mutation_largethan1_nm_vep_coding_disease.txt 计算revel_score.
   得有revel_score的文件 simple_somatic_mutation_largethan1_nm_vep_coding_revel.txt 
   得没有revel_score的文件 simple_somatic_mutation_largethan1_nm_vep_coding_no_revel.txt 

cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/simple_somatic_mutation_largethan1_nm_vep_coding_disease.txt" simple_somatic_mutation_largethan1_nm_vep_coding_disease.vcf

9 kggseq 文件夹为计算kggseq相关操作。



/f/Tools/bcftools/bcftools-1.3.1/bcftools view -v snps simple_somatic_mutation.aggregated.norm.vcf.gz  -O z -o simple_somatic_mutation.aggregated.norm.snp.vcf.gz #将simple_somatic_mutation.aggregated.norm.vcf.gz的snp 筛选出来。


cat simple_somatic_mutation_largethan1_nm_vep_true_noncoding.txt | perl -ane '{next if ($_ =~ /^ID/); my @p= split(/\t/,$_); print $p[1]."\t".$p[2]."\n" }' | sort -u  > unique_ICGC_all_noncoding.txt
生成unique_ICGC_all_noncoding.txt  共3608711 行.

cat simple_somatic_mutation_largethan1_nm_vep_coding.txt | perl -ane '{next if ($_ =~ /^ID/); my @p= split(/\t/,$_); print $p[1]."\t".$p[2]."\n" }' | sort -u  > unique_ICGC_all_coding.txt
生成unique_ICGC_all_coding.txt 共513809行.