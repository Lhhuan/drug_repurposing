#python predict_result.py #此时的cutoff为0.47
# perl 01_connect_snp_gene.pl
# perl 02_classify_gene_and_emerge_bed.pl
#因为在01_connect_snp_gene.pl中找的gene，有的一个variant对应多个gene,所以这里所有的variant都用gencode 的临近基因法找。
perl 02_transfrom_bed.pl #把ds_res.csv转成.bed,得文件02_noncoding_path.bed

sort -k 1,1 -k2,2n 02_noncoding_path.bed > 02_sorted.bed 
bedtools sort -i ./gencode/gencode.v28lift37.basic.annotation.gtf > sorted_gencode.v28lift37.basic.annotation.gtf
bedtools closest -a 02_sorted.bed -b  sorted_gencode.v28lift37.basic.annotation.gtf |sort -u > find_closest.bed
perl 03_filter_noncoding_snp_gene.pl
perl 04_connect_noncoding_path_mutation.pl
Rscript 01.2_mygene_tf2_ensg_symbol.R
cat transform.txt | perl -ane 'chomp;@f=split/\t/;unless(/^query/){print "$f[0]\t$f[3]\n";} ' | sort -u > cosmic_noncoding_path_ensg_symbol_tran.txt