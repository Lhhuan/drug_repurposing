wget http://ldsc.broadinstitute.org/static/media/LD-Hub_study_information_and_SNP_heritability.xlsx 获取LD_HUB的总结表
将UKBB_biobank/ukbb_biobank1_woman_sential_system.txt和GWAS_Catalog/GWAS_Catalog_summary_woman_sential_system.txt 合起来得文件summary_woman_sential_system.txt
cat ./UKBB_biobank/ukbb_biobank1_no_woman_sential_system.txt | perl -ane '@f=split/\t/;unless(/^File_name_Downloaded/){print "$f[1]\n"};' > all_indication_outside_of_reproduction.txt
cat ./GWAS_Catalog/GWAS_Catalog_summary_no_woman_sential_system.txt | perl -ane '@f=split/\t/;unless(/^File_name_Downloaded/){print "$f[1]\n"};' >> all_indication_outside_of_reproduction.txt
cat ./LD_hub/LD_hub_gwas_summary_statistic_mannual_fill_v2.txt | perl -ane '@f=split/\t/;unless(/^File_name_Downloaded/){print "$f[1]\n"};' >> all_indication_outside_of_reproduction.txt
cat ./GRASP/GRASP_mannual_fill.txt | perl -ane '@f=split/\t/;unless(/^File_name_Downloaded/){print "$f[1]\n"};' >> all_indication_outside_of_reproduction.txt
cat all_indication_outside_of_reproduction.txt | sort -u > uni_all_indication_outside_of_reproduction.txt
cp uni_all_indication_outside_of_reproduction.txt uni_ID_all_indication_outside_of_reproduction.txt
#手动为uni_ID_all_indication_outside_of_reproduction.txt添加一列ID
merge_four_source_table.pl将四个数据库的统计表合为一个。#这里不包括女性生殖系统的数据。得文件all_gwas_summary_v1.txt
merge_do_summary.pl 将all_gwas_summary_v1.txt和mapin的do merge 起来,得all_gwas_summary_v2.txt
merge_hpo_summary.pl 将all_gwas_summary_v2.txt和mapin的hpo merge 起来，得all_gwas_summary_v3.txt
将summary_woman_sential_system.txt与all_gwas_summary_v3.txt连起来，得所有的GWAS summary数据。final_gwas_summary.txt
cat all_gwas_summary_v3.txt | perl -ane 'chomp; @f=split/\t/;print"$_\n";' > final_gwas_summary.txt
cat summary_woman_sential_system.txt | perl -ane 'chomp;@f=split/\t/;unless(/^File_name_Downloaded/){print "$_\n"};' >> final_gwas_summary.txt
cat final_gwas_summary.txt | sort -t $'\t'  -k9,9V > final_gwas_summary_sort.txt
filter_cancer.pl #挑出final_gwas_summary_sort.txt中的cancer相关的数据得文件summary_cancer.txt,非cancer相关文献summary_outside_cancer.txt
#
cp summary_cancer.txt summary_cancer_revise.txt 

#手动为summary_cancer_revise.txt加最后一列Normalized_file ,手动在最后一列添加是否可以进行paintor
#在整理过程中发现，下载时由于是同一种疾病而合在一起的文件，有的header不一样，所以，以下发现header 不一样的文件分开写，记录为两条记录。比如123_cancer1,123_cancer2。在summary_cancer_revise.txt中进行修改。以下文件均为修改后的.
perl add_Normalized_file_outside_cancer.pl #为文件summary_outside_cancer.txt在最后加一列Normalized_file，得文件summary_outside_cancer_revise.txt

perl filter_CAD.pl #为文件summary_outside_cancer.txt在最后加一列筛选出CAD相关数据，得CAD文件CAD.txt，非CAD，非cancer文件summary_outside_cancer_CAD_revise.txt
#由于有的文章一篇pmid 包括多个trait,而如果用pmid_trait作为一个字段去筛又会漏掉（数据不规整），所以手动把CAD.txt的
FritscheAMDGene2013_Advanced_v_Controls.txt	Age-related macular degeneration	Fritsche LG	162982			23455636	2013	Mixed	"European, Asian(162982)|ALL(162982)"	GRASP/23455636	FritscheAMDGene2013_Advanced_v_Controls.txt	23455636_Age-related_macular_degeneration.txt	https://grasp.nhlbi.nih.gov/FullResults.aspx		hg19	DOID:10871	age related macular degeneration	NA	NA	23455636_Age-related_macular_degeneration_normalized.txt
Fritsche_AMDGene2013_GeographicAtropy_v_Controls.txt	Geographic atrophy	Fritsche LG	162982			23455636	2013	Mixed	"European, Asian(162982)|ALL(162982)"	GRASP/23455636	Fritsche_AMDGene2013_GeographicAtropy_v_Controls.txt	23455636_Geographic_atrophy.txt	https://grasp.nhlbi.nih.gov/FullResults.aspx		hg19	NA	NA	HP:0031609	Geographic atrophy	23455636_Geographic_atrophy_normalized.txt
两行手动放到summary_outside_cancer_CAD_revise.txt，得CAD_final.txt和summary_outside_cancer_CAD_revise_final.txt

perl add_paintor_result_address.pl #基于summary_cancer_revise_paintor_note.txt 把ukbb的paintor 结果填充，得文件summary_cancer_revise_paintor_note_address.txt
cp summary_cancer_revise_paintor_note_address.txt summary_cancer_revise_paintor_note_address_m.txt
手动修改除ukbb 外的paintor结果位置 ，得summary_cancer_revise_paintor_note_address_m.txt