01_coding_revel_score.pl 为Cosmic_all_coding.txt 计算revel_score.
   得有revel_score的文件 Cosmic_all_coding_revel.txt 
   得没有revel_score的文件 Cosmic_all_coding_no_revel.txt

cat Cosmic_all_coding_revel.txt | perl -ane '{next if($_ =~ /^chr/);@f = split/\t/;if ($f[3]>0.5){print "$f[0]\t$f[3]\n"}}' | sort -u > unique_largethan0.5_driver_mutation.txt

将文件Cosmic_all_coding_revel.txt中revel score大于0.5的数据筛选出来并去重得文件unique_largethan0.5_driver_mutation.txt，共 48364行。

cat Cosmic_all_coding_revel.txt | perl -ane '{next if($_ =~ /^chr/);@f = split/\t/;print "$f[0]\t$f[3]\n"}' | sort -u > unique_driver_mutation.txt
将文件Cosmic_all_coding_revel.txt中按$f[0]进行去重，得去重得文件unique_driver_mutation.txt，共197077行

02_filter_no_revel.pl   过滤Cosmic_all_coding_no_revel.txt中的stop_gained、stop_lost、start_lost，出现这些的认为是致病性的突变。
得包括致病突变的非致病性的突变文件Cosmic_all_coding_no_revel_path.txt，得致病性文件Cosmic_all_coding_no_revel_path.txt

cat Cosmic_all_coding_no_revel_path.txt | perl -ane '{next if($_ =~ /^chr/);@f = split/\t/;print "$f[0]\n"}' | sort -u > unique_no_revel_path.txt
将文件Cosmic_all_coding_no_revel_path.txt中按$f[0]进行去重，得去重得文件unique_no_revel_path.txt，共13432行。

03_filter_no_revel_no_path.pl 将文件Cosmic_all_coding_no_revel_path.txt中的致病性的突变删掉,得文件Cosmic_all_coding_no_revel_no_path1.txt