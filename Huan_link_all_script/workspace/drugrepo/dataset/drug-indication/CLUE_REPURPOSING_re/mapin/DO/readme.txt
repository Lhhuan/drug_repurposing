doid.owl疾病本体推断层次结构包括解剖学，起源细胞，感染因子和表型公理
doid.obo疾病本体层次结构（该文件相当于DO的以前的HumanDO.obo文件）



推荐用doid.obo
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/mapin_ontology/disease_ontology/id-term.txt"  ID-term.txt
为文件05_no_indication.txt加一列序号得文件05_no_indication_id.txt
将文件2GUVSFJ.mapin中term和hpid对应信息提出得文件ID-term.txt

step1:将mapin的term，hpid和对应的indication生成一张表，得文件01_indication_do_term.txt。
      在hpo中没有mapin的indiacation得文件01_indication_no_do_term.txt,共65行。

 cat 01_indication_do_term.txt | perl -ane '{next if($_ =~ /^ID/);my @f= split/\t/; print "$f[2]\n"}' | sort -u > unique_map_do.txt
为step1_indication_do_term.txt文件按照doid去重，得unique_map_do.txt， 共71行
 
 共有indication 65+71=136个。