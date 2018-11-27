由predict_results.ipynb脚本提出score>0.47的位点。得文件ds_res.csv
01_connect_snp_gene.pl将文件ds_res.csv在上一级目录Cosmic_all_ref_alt.txt中找vep注释信息。得文件01_noncoding_path_vep.txt
02_classify_gene_and_emerge_bed.pl 将文件01_noncoding_path_vep.txt分为有基因的文件02_noncoding_path_gene.txt,并且将没有基因的位点转成bed格式，得文件02_noncoding_path_no_gene.bed .


#cat 02_noncoding_path_no_gene.bed | sort -u > sort.bed
bedtools closest -a 02_noncoding_path_no_gene.bed -b  ./gencode/gencode.v28lift37.basic.annotation.gtf
bedtools closest -a sort.bed -b  ./gencode/gencode.v28lift37.basic.annotation.gtf


sort -k 1,1 -k2,2n 02_noncoding_path_no_gene.bed > 02_sorted.bed 
bedtools sort -i ./gencode/gencode.v28lift37.basic.annotation.gtf > sorted_gencode.v28lift37.basic.annotation.gtf
bedtools closest -a 02_sorted.bed -b  sorted_gencode.v28lift37.basic.annotation.gtf > find_closest.bed
bedtools closest -a 02_sorted.bed -b  sorted_gencode.v28lift37.basic.annotation.gtf |sort -u > find_closest.
03_filter_noncoding_snp_gene.pl将find_closest.bed文件中的snp和最邻近的基因选出来。得文件03_noncoding_gene.txt
04_connect_noncoding_path_mutation.pl 将03_noncoding_gene.txt中的突变与"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/v84_classify2/3times/All_cosmic_Muts_largethan2_nm.vcf"
进行交叉，得到特定突变对应的mutation_id.得文件04_noncoding_path_mutation_id.txt
用01.2_mygene_tf2_ensg_symbol.R 将04_noncoding_path_mutation_id.txt 中的ENSG_ID转成symbol.得transform.txt
cat transform.txt | perl -ane 'chomp;@f=split/\t/;unless(/^query/){print "$f[0]\t$f[3]\n";} ' | sort -u > cosmic_noncoding_path_ensg_symbol_tran.txt