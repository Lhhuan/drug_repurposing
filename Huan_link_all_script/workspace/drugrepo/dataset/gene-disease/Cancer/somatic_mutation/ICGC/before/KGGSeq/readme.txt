1  cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/simple_somatic_mutation_largethan1_nm_vep_coding_disease.txt" simple_somatic_mutation_largethan1_nm_vep_coding_disease.vcf


2  cat simple_somatic_mutation_largethan1_nm_vep_coding_disease.vcf | perl -ane '{next if ($_ =~ /^position/); my @p= split(/:/,$F[0]); print"chr". $p[0]."\t".$p[1]."\t".$F[1]."\t".$F[2]."\t".$F[4]."\n" }' | sort -u  > simple_norm_nm_largethen1_coding.vcf

3  java -Xmx3g -jar /f/Tools/kggseq/kggseq10hg19/kggseq.jar --vcf-file simple_norm_nm_largethen1_coding.vcf --out kggscore --vcf --db-gene refgene,gencode --gene-feature-in 0,1,2,3,4,5,6,7 --db-score dbnsfp --cancer-driver-predict --filter-nondisease-variant

得文件kggscore.flt.txt.gz

4  gzip -d kggscore.flt.txt.gz 
 得文件kggscore.flt.txt

5 01_exact_driver_mutation.pl 将文件kggscore.flt.txt 中的driver mutation 提出，得文件 simple_somatic_mutation_largethan1_nm_coding_driver.txt ，共643个。