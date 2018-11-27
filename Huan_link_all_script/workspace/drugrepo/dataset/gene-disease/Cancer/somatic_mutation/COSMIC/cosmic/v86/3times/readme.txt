01_codingthan2.pl 将coding 文件中，出现两次以上的variant筛选出来。 
01_noncodingthan2.pl 将noncoding 文件中，出现两次以上的variant筛选出来。

nohup  /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicNonCodingVariants_largethan2_nm.vcf  -o CosmicNonCodingVariants_largethan2_nm_vep.vcf --cache --offline --fork 20  --symbol --gene --total_length > nohup.out &


nohup  /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicCodingMuts_largethan2_nm.vcf  -o CosmicCodingMuts_largethan2_nm_vep.vcf --cache --offline --fork 20  --symbol --gene --total_length > ../nohup.out &

02_merge_all_coding_and_noncoding.pl 将所有的largethan2_nm(CosmicNonCodingVariants_largethan2_nm.vcf CosmicCodingMuts_largethan2_nm.vcf)的数据合在一起，得文件All_cosmic_Muts_largethan2_nm.vcf ,共474958行。为后来分类后的coding和noncoding寻找ref和alt做铺垫。

03_connect_vep_vcf.pl 为CosmicNonCodingVariants_largethan2_nm_vep.vcf 和 CosmicCodingMuts_largethan2_nm_vep.vcf添加ref 和 alt等信息,得文件Cosmic_all_ref_alt.txt

04_revel.pl 为Cosmic_all_ref_alt.txt寻找revel score，得有revel score的文件cosmic_revel_score.txt 得没有revel score的文件cosmic_no_revel_score.txt

cat cosmic_revel_score.txt | perl -ane '{next if($_ =~ /^chr/);@f = split/\t/;if ($f[3]>=0.5){print "$f[0]\t$f[3]\n"}}' | sort -u > unique_largethan0.5_revel_score.txt
将文件cosmic_revel_score.txt中revel score大于0.5的数据筛选出来并去重得文件unique_largethan0.5_revel_score.txt，共39260行 。

cat cosmic_revel_score.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/;if ($f[3]<0.5){print "$_\n"}}' | sort -u > smallthan0.5_revel_score.txt
将文件cosmic_revel_score.txt中revel score大于0.5的数据筛选出来并去重得文件smallthan0.5_revel_score.txt 

cat smallthan0.5_revel_score.txt | perl -ane 'chomp; {next if($_ =~ /^chr/); @f = split/\t/; print "$f[0]\t$f[4]\t$f[5]\t$f[6]\t$f[7]\n"}' | sort -u > cosmic_all_no_revel_score.txt
cat cosmic_no_revel_score.txt | perl -ane 'chomp;{next if($_ =~ /^chr/);print "$_\n"}' | sort -u >> cosmic_all_no_revel_score.txt 
得所有的没有revel score 数据的文件cosmic_all_no_revel_score.txt


cat 123.txt | perl -ane 'chomp; {next if($_ =~ /^chr/);@f = split/\t/;if ($f[3]<0.5){print "$_\n"}}' | sort -u > 456.txt


cat hg19_spidex.txt | perl -ane 'unless(/^#/){@f = split/\t/;$s= $f[2]-$f[1];print "$s\n" }' | sort -u > 123.txt
检查hg19_spidex.txt的start 和 end 是否是同一位置。

05_spzdex.pl 为cosmic_all_no_revel_score.txt文件寻找spzdex score ， 得有spzdex score的文件cosmic_spzdex_score.txt，得没有spzdex score的文件cosmic_no_spzdex_score.txt

cat cosmic_spzdex_score.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/;if($f[1] >= 0){print "$f[0]\t$f[1]\t$f[2]\n"; }}' | sort -u > unique_spzdex_score_largethan0.txt
将文件cosmic_spzdex_score.txt 得spzdex的dpsi_max_tissue大于等于0的去重文件 unique_spzdex_score_largethan0.txt 共 85394行

cat cosmic_spzdex_score.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/;if($f[1] <0){print "$f[0]\t$f[3]\t$f[4]\t$f[5]\t$f[6]\n"; } }' | sort -u > spzdex_score_smallthan0.txt
将文件cosmic_spzdex_score.txt 得spzdex的dpsi_max_tissue小于0的去重文件 spzdex_score_smallthan0.txt 

cat spzdex_score_smallthan0.txt | perl -ane 'chomp;{next if($_ =~ /^chr/);print "$_\n"}' | sort -u > cosmic_all_no_spzdex_score.txt 
cat cosmic_no_spzdex_score.txt | perl -ane 'chomp;{next if($_ =~ /^chr/);print "$_\n"}' | sort -u >> cosmic_all_no_spzdex_score.txt 

06_mannal_filter.pl 将cosmic_all_no_spzdex_score.txt中的stop_gained, stop_lost, start_lost, frameshift_variant, transcript_ablation, transcript_amplification, inframe_insertion, inframe_deletion选出，
得文件有这些vep的文件cosmic_mannal.txt， 得没有这些vep的文件cosmic_no_mannal.txt
07_filter_occur.pl 过滤掉在mannal 和 no mannal都出现的数据，得cosmic_true_no_mannal.txt
cat unique_largethan0.5_revel_score.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/; print "$f[0]\n"}' | sort -u > cosmic_all_coding_path.txt
cat unique_spzdex_score_largethan0.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/; print "$f[0]\n"}' | sort -u >> cosmic_all_coding_path.txt
cat cosmic_mannal.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/; print "$f[0]\n"}' | sort -u >> cosmic_all_coding_path.txt
cat cosmic_all_coding_path.txt | sort -u >cosmic_all_uni_coding_path.txt 得所有的unique的可以算为编码区的突变文件cosmic_all_uni_coding_path.txt 有 135350行

07_filter_occur.pl 因为有的数据既有mannal中出现的标注，也有mannal中没有出现的标注。此脚本对cosmic_no_mannal.txt中出现在cosmic_no_mannal.txt中的进行去除。
cat cosmic_true_no_mannal.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/; unless($f[0]=~/MT/){print "$_\n"}}' | sort -u >cosmic_true_filter_no_mannal.txt 有844763行。
将染色体号为MT的筛掉。
cat cosmic_true_filter_no_mannal.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/; print "$f[0]\n"}' | sort -u >unique_no_coding_path.txt 有339547行。

08_split_no_coding_path_tab.pl 将文件unique_no_coding_path.txt按照\t分割输出，得文件08_split_tab_no_coding_path.txt 这个文件用张老师的model跑。,跑的结果放在for_huanhuan





09_connect_variant_to_cancer.pl 用Cosmic_all_ref_alt.txt文件将变异(mutation_id)与特定的癌症联系起来。得连起来的文件09_Cosmic_all_ref_alt_cancer.txt，不能和cancer联系起来的mutation文件，09_Cosmic_all_ref_alt_no_cancer.txt
091_connect_variant_to_cancer.pl 用All_cosmic_Muts_largethan2_nm.vcf文件将变异(mutation_id)与特定的癌症联系起来。得连起来的文件091_Cosmic_all_ref_alt_cancer.txt，不能和cancer联系起来的mutation文件，091_Cosmic_all_ref_alt_no_cancer.txt
两者得到的结果是一样的，运行那个都可以
09_connect_variant_to_cancer.pl 和 091_connect_variant_to_cancer.pl的输入有错误，每个mutation 只留下一个mutation id 。 另一输入也问题。
10_all_occur_more_than2_mutation_id_info.pl (此脚本由01_codingthan2.pl改编而来)将所有的出现(snp和indel)次数大于2的mutation_id和其他信息都提取到一个文件，得文件10_all_occur_more_than2_mutation_id_info.txt
11_connect_variant_to_cancer.pl 用10_all_occur_more_than2_mutation_id_info.txt(包括SNP和indel)和01_merge_coding_and_noncoding_mutation_id_cancer_type.txt（上一级目录）通过mutation_id 将变异与特定的cancer联系起来。

12_statistics_original_cosmic.pl #统计没有条件筛选时，unique 的 Chrome:pos.ref.alt 得文件12_original_cosmic.txt 有 20909664个

张老师跑：

nohup  /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicNonCodingVariants_num.vcf  -o CosmicNonCodingVariants_num_vep.vcf --cache --offline --fork 15  --symbol > nohup.out &


nohup  /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicNonCodingVariants_num.vcf  -o CosmicNonCodingVariants_num_vep.txt --tab  --cache --offline --fork 15  --symbol > nohup.out &




nohup  /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  123_test.vcf  -o 123_test_vep.txt --tab  --cache --offline --fork 15  --symbol --gene --total_length > nohup.out &










