perl 01_merge_three_source_driver.pl #将三个source 的driver（../DoCM/version_3.2/variants.tsv, ../29625053_Comprehensive/driver_mutation.txt 和 ../29533785_system/mutation.txt）
#merge到一起,得./output/three_source_driver.txt
perl 02_transvar_hgvsg.pl #为./output/three_source_driver.txt transvar 转换成hgvsg. 得文件./output/02_transvar_hgvsg.txt