cat 06_used_to_build_db_uniparc.txt  08_filter_uniparc_in_random.txt > In_db_and_random_uniparc.txt
/f/mulinlab/huan/tools/ncbi-blast-2.9.0+/bin/makeblastdb -in  06_used_to_build_db_uniparc.txt -dbtype prot
/f/mulinlab/huan/tools/ncbi-blast-2.9.0+/bin/makeblastdb -in  In_db_and_random_uniparc.txt -dbtype prot
/f/mulinlab/huan/tools/ncbi-blast-2.9.0+/bin/makeblastdb -in  In_db_uniparc_and_homo_in_swissprot.txt -dbtype prot