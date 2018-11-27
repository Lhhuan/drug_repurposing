perl prapare_metis.pl
cat ppi.index_metis.txt| sort -t $'\t' -k1,1n | perl -ane 'chomp; @f= split/\t/;$k = join ("\t",@f[1..$#f]); print"$k\n"; ' > ppi.index_metis_input.txt #手动为该文件添加header：13801  123564  001   #123564-13= 123551  13801 123551  001
/f/mulinlab/huan/tools/metis-5.1.0/bin/gpmetis ppi.index_metis_input.txt 80
perl prapare_W2_metis.pl
cat w2_metis.txt| sort -t $'\t' -k1,1n | perl -ane 'chomp; @f= split/\t/;$k = join ("\t",@f[1..$#f]); print"$k\n"; ' > w2_ppi_metis_input.txt #手动为该文件添加header：13801  123564  001   #123564-13= 123551
/f/mulinlab/huan/tools/metis-5.1.0/bin/gpmetis w2_ppi_metis_input.txt 80 

#目前这个文件夹的所以数据都是没有用的