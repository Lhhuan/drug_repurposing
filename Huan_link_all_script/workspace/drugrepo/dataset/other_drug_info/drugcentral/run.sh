cat drug.target.interaction.tsv | cut -f1 | sort -u >unique_all_drug.txt #计数所有的drug个数，2376
perl test.pl # 把drug.target.interaction.tsv里ACT_VALUE不为0的unique的drug，得have_value_drug.txt #1855
