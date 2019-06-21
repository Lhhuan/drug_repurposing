perl 01_merge_all_actionable_driver.pl #将../in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt 和../out_ICGC/output/01_unique_all_driver_actionable_out_ICGC.txt merge 到一起，
#其中不在../in_ICGC/output/02_unique_all_driver_actionable_in_pathogenicity_ICGC.txt 中 的mutation 是新加的，
#"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/out_icgc_add_cgi.txt" #是新加的,包括未经筛选的mutation(比如没有cancer的)
#得./output/01_all_actionable_driver_mutation.txt