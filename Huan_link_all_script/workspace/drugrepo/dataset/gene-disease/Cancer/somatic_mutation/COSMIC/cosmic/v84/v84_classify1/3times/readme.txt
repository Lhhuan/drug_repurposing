01_codingthan1.pl 将coding 文件中，出现三次以上的variant筛选出来。
01_noncodingthan1.pl 将noncoding 文件中，出现三次以上的variant筛选出来。

nohup  /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicNonCodingVariants_largethan2_nm.vcf  -o CosmicNonCodingVariants_largethan2_nm_vep.vcf --cache --offline --fork 24  --symbol > nohup.out &


nohup  /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicCodingMuts_largethan2_nm.vcf  -o CosmicCodingMuts_largethan2_nm_vep.vcf --cache --offline --fork 24  --symbol > nohup1.out &

02_classify_coding_vep.pl将coding文件largethan2vep的数据进行分类，
    得CosmicCodingMuts_largethan2_nm_vep_noncoding.txt和 CosmicNonCodingVariants_largethan2_nm_vep_coding.txt
02_classify_noncoding_vep.pl 将noncoding文件largethan2vep的数据进行分类，
    得CosmicNonCodingVariants_largethan2_nm_vep_noncoding.txt和CosmicNonCodingVariants_largethan2_nm_vep_coding.txt

因为如果一个variant只要hit到coding里面的一个，就算coding，
03_filter_coding_largethan2_nm_vep_noncoding.pl对非编码区文件CosmicCodingMuts_largethan2_nm_vep_noncoding.txt进行进一步过滤，得到只在非编码区存在的variant,得文件CosmicCodingMuts_largethan2_nm_vep_true_noncoding.txt
03_filter_noncoding_largethan2_nm_vep_noncoding.pl对非编码区文件CosmicNonCodingVariants_largethan2_nm_vep_noncoding.txt进行进一步过滤，得到只在非编码区存在的variant，得文件CosmicNonCodingMuts_largethan2_nm_vep_true_noncoding.txt

04_merge_coding.pl 将所有的coding variant合并到一个文件中，得文件Cosmic_all_coding.txt
04_meger_noncoding.pl 将所有的noncoding variant 合并到一个文件中，得文件Cosmic_all_noncoding.txt

05_merge_all_coding_and_noncoding.pl 将所有的largethan2_nm(CosmicNonCodingVariants_largethan2_nm.vcf CosmicCodingMuts_largethan2_nm.vcf)的数据合在一起，得文件All_cosmic_Muts_largethan2_nm.vcf 为后来分类后的coding和noncoding寻找ref和alt做铺垫。

06_coding_connect_classify_vcf.pl 为Cosmic_all_coding.txt添加ref 和 alt等信息。
06_noncoding_connect_classify_vcf.pl 为Cosmic_all_noncoding.txt添加ref 和 alt等信息。

到REVEL文件夹进行score的计算。

cat Cosmic_all_coding.txt | perl -ane '{next if ($_ =~ /^ID/); my @p= split(/\t/,$_); print $p[1]."\t".$p[2]."\n" }' | sort -u  > unique_Cosmic_all_coding.txt

cat Cosmic_all_noncoding.txt | perl -ane '{next if ($_ =~ /^ID/); my @p= split(/\t/,$_); print $p[1]."\t".$p[2]."\n" }' | sort -u  > unique_Cosmic_all_noncoding.txt

unique_Cosmic_all_coding.txt共有314918行   unique_Cosmic_all_noncoding.txt共有176948行。


