01_handle.pl 将上一级目录中的01_cosmic_coding_path_info.txt进行处理，得基因的突变类型文件01_gene_vairant_type.txt

perl 01_handle.pl | sort -u > 01_gene_variant_type.txt

02_filter_variant_type.pl 把文件01_gene_variant_type.txt中mutation的特定类型筛选出来。
    得truncating_mutations文件02_filter_variant_truncating_mutations.txt
    得mutation文件02_filter_variant_mutation.txt

03_MUTS_trunc_mutfreq.pl 算出feature所需MUTS_trunc_mutfreq得文件03_MUTS_trunc_mutfreq.txt。