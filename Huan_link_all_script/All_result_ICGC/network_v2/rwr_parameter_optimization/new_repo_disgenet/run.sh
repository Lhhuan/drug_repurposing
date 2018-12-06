#在网站http://repurposedb.dudleylab.org/browseDrugs/ 查看drug indication的证据支持，然后把ID记录下来，得文件drug_triples_supported_by_FDA.txt 
perl 01_filter_drug_secondary_evidence_by_fda.pl #把文件RepurposeDB_Triples.txt按照ID把FDA支持的drug_secondary筛选出来，得文件，01_drug_secondary_evidence_by_fda.txt,得到没有在RepurposeDB_Triples.txt中存在的drug列表01_drug_no_in_repurposeDB.txt
#查看 01_drug_no_in_repurposeDB.txt中的drug，在网页http://repurposedb.dudleylab.org/browseDrugs/ 上都有secondary indication,把这一部分信息在网页上手动获取，得到和RepurposeDB_Triples.txt格式一样的文件01_mannual_RepurposeDB_Triples.txt
cat 01_drug_secondary_evidence_by_fda.txt 01_mannual_RepurposeDB_Triples.txt > 01_all_drug_secondary_evidence_by_fda.txt #得到所有的FDA支持的drug_secondary_indication文件
cat 01_all_drug_secondary_evidence_by_fda.txt | perl -ane 'chomp; @f= split/\t/;unless(/^rxid/){print "$f[3]\n";}' | sort -u | perl -ane 'chomp;unless($_ =~/^$/){print"$_\n";}' >unique_secondary_indication.txt #

# cat all_gene_disease_associations.tsv | perl -ane 'chomp;@f=split/\t/;unless(/^geneId/){if($f[4]>0.001){print "$f[3]\n";}}'| sort -u > unique_score_more_than_0.0001_disgenet.txt
# cat curated_gene_disease_associations.tsv | perl -ane 'chomp;@f=split/\t/;unless(/^geneId/){print "$f[3]\n";}'| sort -u > unique_score_more_than_0.0001_disgenet2.txt
#手动从DisGeNET搜素unique_secondary_indication.txt里面的disease gene，得文件unique_secondary_indication_gene.txt
perl 02_get_drug_repo_disease_gene.pl #将01_all_drug_secondary_evidence_by_fda.txt和unique_secondary_indication_gene.txt联系起来，得有gene的repo disease文件:02_drug_secondary_evidence_by_fda_gene.txt
#没有gene的文件02_drug_secondary_evidence_by_fda_no_gene.txt，有gene的repo disease及其基因列表的文件02_drug_secondary_evidence_by_fda_gene_list.txt
cat 02_drug_secondary_evidence_by_fda_gene.txt | sort -k1,1n > 02_sorted_drug_secondary_evidence_by_fda_gene.txt #为02_drug_secondary_evidence_by_fda_gene.txt按照药物编号进行排序。
#用02_sorted_drug_secondary_evidence_by_fda_gene.txt为每个drug选一个repo_disease得文件drug_secondary_single_evidence_by_fda_gene.txt

cat 02_sorted_drug_secondary_evidence_by_fda_gene.txt | perl -ane 'chomp;@f=split/\t/;print "$f[0]\n"'| sort -u > 123.txt 

cat 02_sorted_drug_secondary_evidence_by_fda_gene.txt | perl -ane 'chomp;@f=split/\t/;print "$f[0]\t$f[3]\n"'| sort -u > uni_drug_secondary.txt 

cp 02_sorted_drug_secondary_evidence_by_fda_gene.txt 02_sorted_drug_secondary_evidence_by_fda_gene1.txt

perl 03_filter_drug_secondary_evidence_by_fda_gene.pl #筛选出02_sorted_drug_secondary_evidence_by_fda_gene.txt drug primary和secondary 不一样的drug。得03_filter_drug_secondary_ne_primary_evidence_by_fda_gene.txt，#得secondary等于primary文件03_secondary_eq_primary.txt
cat 03_filter_drug_secondary_ne_primary_evidence_by_fda_gene.txt | perl -ane 'chomp; @f= split /\t/; if($f[4]<=5){print "$_\n";}' > 03_filter_drug_lessthan6_secondary_ne_primary_evidence_by_fda_gene.txt
cat 03_filter_drug_secondary_ne_primary_evidence_by_fda_gene.txt | perl -ane 'chomp; @f= split /\t/;unless(/^rxid/){print "$f[0]\n";}' | sort -u > unique_used_repodb_drug.txt

perl 04_get_drug_terget.pl #为03_filter_drug_secondary_ne_primary_evidence_by_fda_gene.txt里面的drug在"/f/mulinlab/huan/All_result/huan_target_drug_indication_final_symbol.txt"寻找target 得有target的药物，04_drug_target_secondary.txt，没有target的药物文件04_drug_no_target_secondary.txt

perl 05_get_drug_target_secondary_gene.pl  #为04_drug_target_secondary.txt的secondary找到gene得文件05_get_drug_target_secondary_gene.txt,得没有gene的secondary文件05_get_drug_target_secondary_no_gene.txt
cat 05_get_drug_target_secondary_gene.txt | perl -ane 'chomp;@f = split/\t/;unless($f[2]=~/NA/){print "$f[0]\t$f[1]\t$f[2]\t$f[4]\t$f[5]\t$f[6]\n";}' | sort -u -k1 > 05_sorted_get_drug_target_secondary_gene.txt #不输出primary

# check review中的10个drug ，Thalidomide、Valproic acid、Celecoxib，Leflunomide， Minocycline， 在05_get_drug_target_secondary_gene.txt中，手动补充部分05_get_drug_target_secondary_gene.txt没有的secondary到01_mannual_RepurposeDB_Triples.txt，得文件并在最后一列加review
# 手动补充部分gene disease 到unique_secondary_indication_gene.txt，并在最后一列写review.
# 重新运行上面所有脚本。
# Aspirin、Statins，Metformin，Rapamycin，Methotrexate，Zoledronic acid，Wortmannin，Vesnarinone，Thiocolchicoside，Nitroxoline，Noscapine不在05_get_drug_target_secondary_gene.txt中
# 因为Nitroxoline，Noscapine两个药物重新定位到的疾病不明确或者疾病基因不明确，所以将这两个药物删掉，不进入下一步。
# 将剩下的药物放进及其repodisease 放到review_drug_repo.txt
perl 06_get_review_repodisease_gene.pl #为review_drug_repo.txt在unique_secondary_indication_gene.txt寻找disease gene，得文件有gene的disease 06_get_review_repodisease_gene.txt，没有gene的disease文件 06_no_disease_gene.txt
#手动为06_no_disease_gene.txt寻找disease，在disgenet上，得文件uni_review_no_gene_disease_gene.txt

cat uni_review_no_gene_disease_gene.txt unique_secondary_indication_gene.txt > all_drepoisease_gene.txt
perl 06_2get_review_repodisease_gene.pl #为review_drug_repo.txt在all_drepoisease_gene.txt 寻找disease gene，得文件有gene的disease 06_2get_review_repodisease_gene.txt，没有gene的disease文件 06_2no_disease_gene.txt
perl 07_get_drug_terget.pl #为06_2get_review_repodisease_gene.txt里面的drug寻找target 得有target的药物，07_review_drug_target_secondary.txt，没有target的药物文件07_review_drug_no_target_secondary.txt

cat 05_sorted_get_drug_target_secondary_gene.txt 07_review_drug_target_secondary.txt | sort -u -k1 > all_sorted_drug_target_repo_gene.txt #得所有的drug_target和repo disease文件。
cat all_sorted_drug_target_repo_gene.txt | perl -ane 'chomp;unless(/^drug_name/){@f= split/\t/;my $repo_symbol = $f[-2];print "$repo_symbol\n"}' | sort -u >uni_repo_symbol.txt #得unique的repo symbol
Rscript 08_trans_repo_symbol_entrezid.R #把uni_repo_symbol.txt的symbol转换成entrezid,得文件08_uni_repo_symbol_entrezid.txt
perl 09_map_all_sorted_drug_target_repo_symbol_entrez.pl #把all_sorted_drug_target_repo_gene.txt的repo symbol换成entrez，得有entrez的文件09_all_sorted_drug_target_repo_symbol_entrez.txt
perl 091_filter_diseae_gene.pl #把09_all_sorted_drug_target_repo_symbol_entrez.txt的每个drug中，在drug target 中出现的gene，在repo disease gene中去掉，得091_filter_all_sorted_drug_target_repo_symbol_entrez.txt

perl 10_map_drug_target_repo_entrez_num.pl #把091_filter_all_sorted_drug_target_repo_symbol_entrez.txt中的所有的drug_target_repo_entrez都map到"/f/mulinlab/huan/All_result/network/network_gene_num.txt"中，得10_all_sorted_drug_target_repo_symbol_entrez_num.txt,用于rwr训练的数据。
cat 10_all_sorted_drug_target_repo_symbol_entrez_num.txt | sort -k1,1V -k5,5V > 10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt

cat 10_sorted_all_sorted_drug_target_repo_symbol_entrez_num.txt | perl -ane 'chomp;unless(/^drug/){@f= split/\t/;print "$f[0]\t$f[4]\n"}' | sort -u  > uni_test_drug_repo_pair.txt
wc -l uni_test_drug_repo_pair.txt  #得进行测试的unique 的drug repo pair 共249个。