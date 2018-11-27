coding_revel_score.pl 为simple_somatic_mutation_largethan1_nm_vep_coding_disease.txt 计算revel_score.
   得有revel_score的文件 simple_somatic_mutation_largethan1_nm_vep_coding_revel.txt 
   得没有revel_score的文件 simple_somatic_mutation_largethan1_nm_vep_coding_no_revel.txt 

cat simple_somatic_mutation_largethan1_nm_vep_coding_revel.txt | perl -ane '{next if($_ =~ /^chr/);@f = split/\t/;if ($f[3]>0.5){print "$f[0]\t$f[3]\n"}}' | sort -u > unique_largethan0.5_driver_mutation.txt

将文件simple_somatic_mutation_largethan1_nm_vep_coding_revel.txt中revel score大于0.5的数据筛选出来并去重得文件unique_largethan0.5_driver_mutation.txt，共18447行。

cat simple_somatic_mutation_largethan1_nm_vep_coding_revel.txt | perl -ane '{next if($_ =~ /^chr/);@f = split/\t/;print "$f[0]\t$f[3]\n"}' | sort -u > unique_driver_mutation.txt
将文件simple_somatic_mutation_largethan1_nm_vep_coding_revel.txt中按$f[0]进行去重，得去重得文件unique_driver_mutation.txt，共97178行。
