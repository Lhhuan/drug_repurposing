#对../refine_new_add_drugbank_indication.txt 进行map 到do和hpo
perl merge_add_do_hpo_mapin.pl #对./do/step1_indication_do_term.txt和./hpo/step1_indication_hp_term.txt进行merge，得add_merge_hpo.txt add_merge_do.txt,#将mapin的do成功的和失败的写在一个文件里。#将mapin的hpo成功的和失败的写在一个文件里。
perl merge_mapin2.pl #把add_merge_hpo.txt和add_merge_do.txt merge 成一个文件，得merge_add_hpo_do.txt
#将merge_add_hpo_do.txt map到oncotree得，merge_add_hpo_do_oncotree.txt
perl substitute.pl #把merge_add_hpo_do_oncotree.txt里的引号替换成空，得merge_add_hpo_do_oncotree_s.txt