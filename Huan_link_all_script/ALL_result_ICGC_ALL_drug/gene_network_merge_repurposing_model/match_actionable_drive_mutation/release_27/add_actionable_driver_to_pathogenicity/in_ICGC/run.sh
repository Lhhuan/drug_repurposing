perl 01_merge_driver_actionable_in_icgc.pl ##将在ICGC中的actionable 和driver mutation merge 到一起。将../../actionable_mutation/actionable_hit_all_ICGC_mutation/output/04_actionable_mutaton_in_pathogenicity.txt
#和../../driver_mutation/hit_all_ICGC_mutation/output/04_actionable_mutaton_in_pathogenicity.txt
#和/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/in_icgc_add_cgi.txt merge到一起，
#得./output/01_all_driver_action_in_ICGC.txt ,得unique的mutation 文件得./output/01_unique_all_driver_action_in_ICGC.txt
perl 02_merge_driver_actionable_in_icgc_pathogenicity.pl #将在pathogenicity icgc 中的actionable 和driver mutation merge 到一起。
#将../../actionable_mutation/actionable_hit_pathogenic/output/04_actionable_mutaton_in_pathogenicity.txt 和../../driver_mutation/hit_pathogenic/output/04_actionable_mutaton_in_pathogenicity.txt 
#和 "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/in_pathogenicity_cgi.txt"merge到一起，得
#./output/01_all_driver_action_in_pathogenicity_ICGC.txt
cp "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/in_pathogenicity_cgi.txt" ./output/
cp "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/in_icgc_add_cgi.txt" ./output/

