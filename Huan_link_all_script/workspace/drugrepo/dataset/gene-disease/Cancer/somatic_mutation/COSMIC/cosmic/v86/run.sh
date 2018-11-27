cat test_sampleid_.txt | sort -u |sort -k2,2V -k5,5n > test_sampleid_sorted.txt
cat test_coding_sampleid_.txt | sort -u | sort -k2,2V -k5,5n > test_coding_sampleid_sorted.txt
cat test_sampleid_sorted.txt test_coding_sampleid_sorted.txt > all_test_sampleid.txt
perl array_num_count.pl
cat array_count.txt | perl -ane 'chomp;@f= split/\t/;if($f[1]>$f[2]){print "$_\n";}'>num_occur.txt