01_filter_non-synonymous.pl 将上一级目录中01_cosmic_coding_path_info.txt的non-synonymous(missense)和synonymous以及gene_transcript选出来。
02_top_cds.R 选出基因(01_gene_transcript.txt)所对应的最长的转录本,得文件 02_top_gene_transcript.txt
cat cancer_gene_census.txt | perl -ane 'chomp; @f=split/\t/;unless(/^Gene/){print "$f[0]\t$f[13]\n";}' > CGC_phenotype.tsv
并手动添加题头： Symbol 和Cancer Molecular Genetics
oncodriveclust -m 3 --cgc CGC_phenotype.tsv 01_non-synonymous.txt 01_synonymous.txt 02_top_gene_transcript.txt 
运行oncocluster 得结果oncodriveclust-results.tsv
03_extract_gene_clust.pl 选出将上一级目录中01_cosmic_coding_path_info.txt在oncodriveclust-results.tsv clust内基的基因。
perl 03_extract_gene_clust.pl | sort -u >03_gene_clust.txt 
04_MUTS_clusters_miss_VS_pam.pl 计算MUTS_clusters_miss_VS_pam这个feature ，得文件04_MUTS_clusters_miss_VS_pam.txt为最终结果

cat cancer_gene_census.txt | perl -ane 'chomp; @f = split/\t/;print"$f[0]\t$f[14]\n";' > cancer_gene_census_role.txt