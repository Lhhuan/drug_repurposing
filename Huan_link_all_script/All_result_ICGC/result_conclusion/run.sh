cat ../huan_target_drug_indication_final_symbol.txt | perl -ane 'chomp;@f= split/\t/;unless(/^Drug_chembl_id/){print "$f[1]\t$f[-2]\n"}'| sort -u >unqi_drug.txt #将得到最终的药物为6374个。
cat unqi_drug.txt | perl -ane 'chomp; @f= split/\t/;if($f[1]=~/DGIdb/){print "$_\n"}' >dgidb_uni_drug.txt #得到来源于dgidb的unqi drug为6107个
cat unqi_drug.txt | perl -ane 'chomp; @f= split/\t/;unless($f[1]=~/DGIdb/){print "$_\n"}' >CLUE_REPURPOSING_uni_drug.txt #得到来源于CLUE_REPURPOSING的unqi drug为267个。
cat ../huan_target_drug_indication_final_symbol.txt | perl -ane 'chomp;@f= split/\t/;unless(/^Drug_chembl_id/){print "$f[4]\n"}'| sort -u >unqi_Entrez_id_gene.txt ##以Entrez_id基因去重时，得unqi gene 3161个
cat ../huan_target_drug_indication_final_symbol.txt | perl -ane 'chomp;@f= split/\t/;unless(/^Drug_chembl_id/){print "$f[-3]\n"}'| sort -u >unqi_ensg_gene.txt #以ensg基因去重时，得unqi gene 3130个
cat ../huan_target_drug_indication_final_symbol.txt | perl -ane 'chomp;@f= split/\t/;unless(/^Drug_chembl_id/){print "$f[1]\t$f[-3]\n"}'| sort -u >unqi_drug_Entrez_id_pair.txt #以Entrez_id基因去重时，drug_target pair 25710个
cat ../huan_target_drug_indication_final_symbol.txt | perl -ane 'chomp;@f= split/\t/;unless(/^Drug_chembl_id/){print "$f[1]\t$f[4]\n"}'| sort -u >unqi_drug_ensg_pair.txt #以ensg 基因去重时，drug_target pair 25523个

wc ../map_do_refine_fail.txt #有1251个
wc ../uniq_map_do.txt #有1257个
wc ../map_hpo_refine_fail.txt #有1360个
wc ../uniq_map_hpo.txt #有1142个

cat ../huan_target_drug_indication_final_symbol.txt | perl -ane 'chomp;@f= split/\t/;unless(/^Drug_chembl_id/){print "$f[1]\t$f[-1]\n"}'| sort -u >unqi_drug_indication_pair.txt #将得到最终的drug_indication pair 为18173个。 

/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/picture/ #这里的picture表示的有些drug 为什么没有indication
wc -l ../three_source_gene_role_final.txt #已知原癌还是抑癌的基因共2272-2 = 2270个
cat ../three_source_gene_role_final.txt | perl -ane 'chomp;@f=split/\t/;unless(/^Gene*symbol|Gene/){if($f[3]=~/fusion|NONE|"oncogene,/){print "$_\n";}}'> two_pro_gene_role.txt #得有可能是抑癌也有可能是原癌的基因，共435个
cat ../three_source_gene_role_final.txt | perl -ane 'chomp;@f=split/\t/;unless(/^Gene*symbol|Gene/){unless($f[3]=~/fusion|NONE|"oncogene,/){if($f[3]=~/Loss|TSG/){print "$_\n";}}}'> TSG_gene_role.txt  #得抑癌基因共1437个
cat ../three_source_gene_role_final.txt | perl -ane 'chomp;@f=split/\t/;unless(/^Gene*symbol|Gene/){unless($f[3]=~/fusion|NONE|"oncogene,/){if($f[3]=~/oncogene|Oncogene|Activating/){print "$_\n";}}}'> Oncogene_role.txt #得原癌基因398个

#somatic ：coding：110329 个mutation concoding:206860个mutation，对应29380个ensg 基因


cat ../no_drug_somatic_path_gene_role.txt | perl -ane 'chomp;unless(/^ENSG_ID/){@f= split/\t/;print "$f[1]\n";}' | sort -u > no_drug_somatic_mutation.txt #对应270532个somatic mutation 没有drug 可以治疗
cat ../no_drug_somatic_path_gene_role.txt | perl -ane 'chomp;unless(/^ENSG_ID/){@f= split/\t/;print "$f[0]\n";}' | sort -u > no_drug_ensg.txt #对应27151个ENSG 没有drug 可以治疗
cat ../cancer_gene_drug_logic_true.txt | perl -ane 'chomp;unless(/^Chrom/){@f= split/\t/;print "$f[0]\n";}' | sort -u > drug_somatic_mutation_logic_true.txt #对应个15392个somatic mutation对应的drug moa逻辑正确
cat ../cancer_gene_drug_logic_true.txt | perl -ane 'chomp;unless(/^Chrom/){@f= split/\t/;print "$f[-4]\n";}' | sort -u > drug_ENSG-ID_logic_true.txt #对应176个ENSG对应的drug moa逻辑正确
cat ../cancer_gene_drug_logic_conflict.txt | perl -ane 'chomp;unless(/^Chrom/){@f= split/\t/;print "$f[0]\n";}' | sort -u > drug_somatic_mutation_logic_flase.txt # 对应 21425个 somatic mutation对应的drug moa逻辑不正确
cat ../cancer_gene_drug_logic_conflict.txt | perl -ane 'chomp;unless(/^Chrom/){@f= split/\t/;print "$f[-4]\n";}' | sort -u > drug_ENSG_logic_flase.txt #对应143个ENSG对应的drug moa逻辑正确
cat ../no_logic_conflict.txt | perl -ane 'chomp;unless(/^Chrom/){@f= split/\t/;print "$f[0]\n";}' | sort -u > drug_somatic_mutation_no_logic.txt #对应 48018个somatic mutation对应的drug moa没有逻辑
cat ../no_logic_conflict.txt | perl -ane 'chomp;unless(/^Chrom/){@f= split/\t/;print "$f[-4]\n";}' | sort -u > drug_ENSG_no_logic.txt #对应2170个ENSG对应的drug moa没有逻辑



cat ../cancer_gene_drug_information.txt | perl -ane 'chomp; unless(/^Chrom/){@f=split/\t/;print"$f[-4]\n"}' | sort -u > un123.txt
cat  ../cancer_gene_drug_information.txt | cut -f25 | sort -u > 1234.txt
cat ../no_drug_somatic_path_gene_role.txt | cut -f1 |sort -u > 1234.txt