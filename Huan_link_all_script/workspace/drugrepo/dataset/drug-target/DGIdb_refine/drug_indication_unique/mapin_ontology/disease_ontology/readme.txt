

doid.owl疾病本体推断层次结构包括解剖学，起源细胞，感染因子和表型公理
doid.obo疾病本体层次结构（该文件相当于DO的以前的HumanDO.obo文件）

为文件step10-4_unique_indication.txt加一列序号得文件step10-4_unique_indication-id.txt
对照在线mapin将文件1OJQTYN.id-id.mapin的乱码改掉得文件1OJQTYN-id-id-true.txt
将文件1OJQTYN.mapin中term和doid对应信息提出得文件id-term.txt
step1:将mapin的term，doid和对应的indication生成一张表，得文件step1_indication_do_term.txt。
      在do中没有mapin的indiacation得文件step1_indication_no_do_term.txt，共1155行。

cat step1_indication_do_term.txt | perl -ane '{next if($_ =~ /^ID/);my @f= split/\t/; print "$f[2]\n"}' | sort -u > unique_map_do.txt

为step1_indication_do_term.txt按照doid去重，得文件unique_map_do.txt，共921行。
共有indication1155+921=2076个。
