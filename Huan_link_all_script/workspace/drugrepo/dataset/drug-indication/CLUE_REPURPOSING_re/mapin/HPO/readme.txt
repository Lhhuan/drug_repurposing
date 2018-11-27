推测hp.obo为层次结构
推测hp.owl为推断层次结构包括解剖学，起源细胞，感染因子和表型公理


推荐用hp.obo
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/mapin_ontology/human_phenotype_ontology/ID-term.txt"  ID-term.txt
为文件05_no_indication.txt加一列序号得文件05_no_indication_id.txt
将文件2GUVSFJ.mapin中term和hpid对应信息提出得文件ID-term.txt

step1:将mapin的term，hpid和对应的indication生成一张表，得文件01_indication_hp_term.txt。
      在hpo中没有mapin的indiacation得文件01_indication_no_hp_term.txt,共84行。

 cat 01_indication_hp_term.txt | perl -ane '{next if($_ =~ /^ID/);my @f= split/\t/; print "$f[2]\n"}' | sort -u > unique_map_hpo.txt
为step1_indication_hp_term.txt文件按照hpoid去重，得unique_map_hpo.txt， 共53行
 
 共有indication 53+84=137个。