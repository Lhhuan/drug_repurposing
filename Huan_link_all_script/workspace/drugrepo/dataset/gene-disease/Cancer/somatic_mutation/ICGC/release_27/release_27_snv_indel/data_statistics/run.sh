perl statistic_id_project.pl #统计每个mutation id对应的project，统计affected donor >1的id 和Project 得文件ID_project.txt
perl count_project_num.pl #统计ID_project.txt中每个project所对应的mutation id的数目，得文件project_id_num.txt，#并且给每个cancer一个id,得文件cancer_id.txt
perl merge_project_id_num_oncotree.pl #用cancer_id_full_oncotree.txt为project_id_num.txt文件添加oncotree信息。得文件merge_project_id_num_oncotree.txt
perl count_oncotree_mutation_count.pl #计算merge_project_id_num_oncotree.txt文件里每个oncotree_id 对应的的num，得文件oncotree-id_mutation_num.txt

cat oncotree-id_mutation_num.txt | sort -k1,1Vr > sorted_oncotree-id_mutation_num.txt
perl normal_count_project_num.pl #把sorted_oncotree-id_mutation_num.txt里面number 小于10000的加起来作为一个other,得文件final_oncotree-id_mutation_num.txt
cat final_oncotree-id_mutation_num.txt | sort -k2,2Vr > sorted_final_oncotree-id_mutation_num.txt
cp sorted_final_oncotree-id_mutation_num.txt final_oncotree-id_mutation_num_m1.txt
#手动调整final_oncotree-id_mutation_num_m1.txt 得final_oncotree-id_mutation_num_m.txt

#------------------------------------------------
cp cancer_id.txt  cancer_id_full.txt #并手动给cancer_id_full.txt添加project的全称,并在http://oncotree.mskcc.org/#/home map到oncotree，得cancer_id_full_oncotree.txt 