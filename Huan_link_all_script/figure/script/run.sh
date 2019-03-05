Rscript select_mutation_occur.R #画 mutation occurance的图
Rscript random_walk_cutoff.R #画random_walk_cutoff的图
Rscript mutation_sv_occurance.R #统计occurance>2的mutation sv的展示，circle plot
Rscript mutation_occurance_bar_plot.R #画mutation occurance 的图
perl 01_prepare_for_mutation_pathogenicity.pl #为画mutation pathogenicity 准备数据。
# perl 02_prepare_for_mutation_pathogenicity.pl
Rscript mutation_pathogenicity_density_portion_plot.R #致病性突变的密度分布度
Rscript project_sv_snv_Cumulative_bar.R #致病性突变在project上的累计分布图
Rscript Cancer_sv_snv_Cumulative_bar.R #致病性突变在cancer上的累计分布图,及致病性snv/indel在cancer的分布图
Rscript project_map_to_oncotree.R #绘制project map to oncotree的
Rscript Pathogenic_mutation_map_to_gene_level.R #绘制Pathogenic mutation map to gene的饼图
Rscript distribution_of_Pathogenic_gene_MOA.R #绘制 Pathogenic gene moa 的饼图
Rscript distribution_of_drug_repurposing_prediction_value.R #绘制drug repurposing score 的分布
Rscript distribution_of_drug_type.R #绘制cancer drug 和noncancer drug 的type组成图。
Rscript distribution_of_drug_status.R #绘制cancer drug 和noncancer drug 的status组成图。
Rscript gene_based_logic_true_drug_enrichment.R #gene based logic true drug 在cancer 中enrichment
Rscript network_based_logic_true_drug_enrichment.R #gene based logic true drug 在cancer 中enrichment