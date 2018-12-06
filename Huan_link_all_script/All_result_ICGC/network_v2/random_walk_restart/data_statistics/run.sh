cat ../13_network_based_ICGC_somatic_repo_may_success.txt | perl -ane 'chomp;@f= split/\t/;unless(/start_id/){print "$f[7]\t$f[9]\n"}' | sort -u > network_based_may_success_repo.txt
perl 01_uni_network_repo_success_pair.pl # 对../13_network_based_ICGC_somatic_repo_may_success.txt的drug和repo进行提取并且去重，得01_uni_network_repo_success_pair.txt
perl 02_drug_repo_count.pl #统计network_based_may_success_repo.txt中每个癌症被哪些药物治疗，得network_cancer_drug_repo_count.txt
Rscript network_repo_drug_count.R #画图