推测hp.obo为层次结构
推测hp.owl为推断层次结构包括解剖学，起源细胞，感染因子和表型公理


推荐用hp.obo

为文件step10-4_unique_indication.txt加一列序号得文件step10-4_unique_indication-id.txt
将文件2GUVSFJ.mapin中term和hpid对应信息提出得文件ID-term.txt

step1:将mapin的term，hpid和对应的indication生成一张表，得文件step1_indication_hp_term.txt。
      在hpo中没有mapin的indiacation得文件step1_indication_no_hp_term.txt,共1249行。

 cat step1_indication_hp_term.txt | perl -ane '{next if($_ =~ /^ID/);my @f= split/\t/; print "$f[2]\n"}' | sort -u > unique_map_hpo.txt
为step1_indication_hp_term.txt文件按照hpoid去重，得unique_map_hpo.txt， 共712行
 
 共有indication 712+1249=1961个。


