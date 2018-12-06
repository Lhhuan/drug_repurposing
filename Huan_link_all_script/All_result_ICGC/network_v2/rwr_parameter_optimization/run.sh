# wget http://www.disgenet.org/ds/DisGeNET/results/curated_gene_disease_associations.tsv.gz
# gzip -d curated_gene_disease_associations.tsv.gz
perl 01_match_drug-target_disease_gene.pl #对从http://www.disgenet.org/web/DisGeNET/menu/downloads和http://repurposedb.dudleylab.org/browseDrugs/收集的test gene,构造可能存在网络关系，得网络关系start_end.txt和gene的列表test_gene_list.txt。
cat start_end.txt | perl -ane'chomp;@f = split/\t/; unless(/^target/){print "$f[0]\n$f[1]\n"}' |  sort -u > test_gene_list.txt
Rscript 02_test_symbol_to_entrezid.R #把test_gene_list.txt的gene symbol转成entrezid，得文件02_testgene_list_symbol_to_entrez.txt
perl 03_map_test_entrez_to_network.pl  #为调参的start和end的gene symbol转换成entrez和在网络中的编号。分别得文件03_test_symbol_to_entrez_networkid.txt和03_test_start_end_networkid.txt
cat 03_test_start_end_networkid.txt | sort -t $'\t' -k1,1n -k2,2n > 03_test_start_end_networkid_sorted.txt
#review_start_end.txt为文章中找到的4个start和endpair，里面包含基因symbol和networkid 。review_gene_list_symbol_entrezid.txt是review_gene_list的symbol和entrezid。