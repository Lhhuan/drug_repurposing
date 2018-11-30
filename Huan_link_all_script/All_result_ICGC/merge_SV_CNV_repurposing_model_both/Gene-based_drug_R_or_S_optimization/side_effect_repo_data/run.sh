 perl 01_filter_side_effect_from_drugbank.pl #把"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/getfromdrugbank2017-12-18.txt"中side effect 为cancer的药物，得文件01_filter_side_effect_from_drugbank.txt
#把01_filter_side_effect_from_drugbank.txt map 到oncotree的主要组织， 得文件01_filter_side_effect_from_drugbank_oncotree.txt
#在http://sideeffects.embl.de 收集drug的side effect(cancer) 信息，并将得011_drug_side_effect_cancer.txt


#---------------------------------------------------------------------------------------------------------------以下为收集正负样本
perl 02_filter_repo_cancer.pl #把"/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/09_all_sorted_drug_target_repo_symbol_entrez.txt"中repo为cancer的筛选出来，得02_repo_cancer.txt,得02_unique_repo_cancer.txt
#将02_unique_repo_cancer.txt map 到oncotree上，得文件02_repo_cancer_oncotree.txt  #因为这里的cancer后面会用于repo，会需要cancer gene，所以这里对找不到组织(或在多个组织中出现的)的cancer记为NA
perl 03_filter_drug_repo_cancer_oncotree.pl #把02_repo_cancer_oncotree.txt中oncotree term 不是NA的，和02_repo_cancer.txt merge 到一起，得03_filter_drug_repo_cancer_oncotree.txt,得drug和repo oncotree的unique pair 03_unique_drug_repo_oncotree.txt
 #03_filter_drug_repo_cancer_oncotree.txt共有37行数据，03_unique_drug_repo_oncotree.txt也共有37行，所以要准备2倍的负样本，37*2= 74行。
 #从clinical.trial（https://clinicaltrials.gov/ct2/results?cond=Cancer&Search=Apply&recrs=i&age_v=&gndr=&type=&rslt=）中收集的Withdrawn的药品和cancer 并映射到oncotree,得Withdrawn_cancer_drug.txt
 cp /f/mulinlab/sinan/drug_disease_11.2_sinan.xlsx  sinan_withdrawn.xlsx #另存为sinan_withdrawn.txt
 #sinan从clinical.trial（https://clinicaltrials.gov/ct2/results?cond=Cancer&Search=Apply&recrs=i&age_v=&gndr=&type=&rslt=）中收集的Withdrawn的药品和cancer 并映射到oncotree,得Withdrawn_cancer_drug_sinan.txt
 cat Withdrawn_cancer_drug.txt Withdrawn_cancer_drug_sinan.txt > Withdrawn_cancer_drug_huan.txt
 wget -c https://chiragjp.shinyapps.io/repoDB/_w_cb9d017f/session/93a20069a36c082a18d998e860304f87/download/downloadFull?w=cb9d017f #得repoDB_full.csv
perl 0311_filter_cancer_from_repoDB.pl #从repoDB_full.csv中筛出indication 为cancer的信息。得approved的cancer drug info文件0311_filter_cancer_from_repoDB_approved.txt，得被Terminated_or_Withdrawn的cancer drug info文件0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn.txt
cat 0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn.txt | cut -f2 | sort -u > 0311_Terminated_or_Withdrawn_used_mapin.txt #unique 的用于map 到oncotree因为detail term在此处用不到，并且该文件term较多。
#所以这里只map到main term得0311_Terminated_or_Withdrawn_oncotree.txt
perl merge_0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn_oncotree.pl #把0311_Terminated_or_Withdrawn_oncotree.txt 和0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn.txt merge 成一个文件，得0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn_oncotree.txt

cp "/f/mulinlab/huan/All_result_ICGC/16.1_drug_cancer_in_icgc_project.txt" ./huan_drug_indication_cancer.txt
                #----------------------------------------------这里的代码没用到
                    perl 031_emerge_drug_no_function_with_cancer.pl #把"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt" 中的drug，除去出现在"/f/mulinlab/huan/All_result_ICGC/16.1_drug_cancer_in_icgc_project.txt"中的药物，
                    #除去011_drug_side_effect_cancer.txt和01_filter_side_effect_from_drugbank_oncotree.txt中的药物，得031_emerge_drug_no_function_with_cancer.txt
                    perl 032_random_drug_no_function_cancer.pl #把031_emerge_drug_no_function_with_cancer.txt，从"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"中随机选出药物对应的cancer作为负样本。得032_random_drug_no_function_cancer.txt
                    perl 033_random_select_drug_no_function_cancer.pl ##从032_random_drug_no_function_cancer.txt中选取200个，得033_random_select_drug_no_function_cancer.txt
                #-----------------------------------------
#-------------------------------------------------------------------------------
#------------------------------------------------------------
perl 04_merge_repo_side-effect_Withdrawn_data.pl ##把011_drug_side_effect_cancer.txt和03_unique_drug_repo_oncotree.txt, 01_filter_side_effect_from_drugbank_oncotree.txt 以及drug clinical withdrawm的药物信息Withdrawn_cancer_drug_huan.txt merge成一个文件，得文件04_merge_repo_side-effect_withdrawn_data.txt
    perl 041_filter_repo_side-effect_data.pl #04_merge_repo_side-effect_withdrawn_data.txt中，有的同一药物，对于某一疾病既是repo，也是side effect (如：sorafenib对skin),把这种的信息去掉得041_true_repo_side-effect_data.txt
# perl 05_merge_drug_name_data_for_logistic_regression.pl #将"/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" 中的Drug_chembl_id_Drug_claim_primary_name和Drug_claim_primary_name提出来，
# #和"/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model/Gene-based_drug_R_or_S_optimization/huan_data/022_calculate_for_repo_logistic_regression_data.txt" merge 起来
# #得05_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt
# perl 06_filter_repo_withdrwal_data_for_logistic_regression.pl ##根据041_true_repo_side-effect_data.txt中的drug cancer pair 在"05_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt"
# #中提取repo_or_withdrawl 的logistic_regression信息。得./06_filter_repo_withdrwal_data_for_logistic_regression.txt,并把repo和indication的值设为1，Withdrawn|Terminated设为0，
# #得"./06_final_filter_repo_withdrwal_data_for_logistic_regression.txt"





perl 05_extract_drug_info_for_repo_side-effect_data.pl #在"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"中提取041_true_repo_side-effect_data.txt中的drug target 及其score等信息，得05_drug_info_repo_side-effect.txt,得具有以上的信息的文件05_uni_drug_repo_side-effect.txt,
perl 06_merge_repo_side-effect_cancer_gene.pl #用"/f/mulinlab/huan/All_result_ICGC/pathogenicity_mutation_cancer/pathogenicity_mutation_cancer.txt" 将05_drug_info_repo_side-effect.txt中cancer 相关信息提出来，得06_merge_repo_side-effect_cancer_gene.txt
perl 07_judge_drug_target_and_cancer_same_and_logic.pl #判断06_merge_repo_side-effect_cancer_gene.txt中的drug target和cancer gene是否是同一基因，得07_drug_taregt_cancer_gene_same.txt 
#然后判断07_drug_taregt_cancer_gene_same.txt的dru个MOA 和disease MOA逻辑是否一致，得07_drug_taregt_cancer_gene_same_logic.txt
perl 08_filter_logic_know_info.pl #把07_drug_taregt_cancer_gene_same_logic.txt 中logic 不为NA 的筛选出来，并把没有drug target score的补score 为1,得08_logic_not_no_drug_cancer_infos.txt，
#08_logic_not_no_drug_cancer_infos.txt中有些药物和cancer pair 是side effect,但是drug target和cancer gene 的逻辑却都是TRUE,此步骤把这些药物去掉，得文件08_logic_not_no_drug_cancer_infos_check.txt
#cat 08_logic_not_no_drug_cancer_infos_check.txt | sort -k1,1V -k5,5V> 08_sorted_logic_not_no_drug_cancer_infos_check.txt
perl 09_prepare_data_for_repo_logistic_regression.pl #用08_sorted_logic_not_no_drug_cancer_infos_check.txt为做逻辑回归准备数据，得文件09_prepare_data_for_logistic_regression.txt

#-------------------------------------------------------------------------------------------------------------------------------------以上部分可以算作是收集数据
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
perl 10_merge_drug_name_data_for_logistic_regression.pl ##将"/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" 中的Drug_chembl_id_Drug_claim_primary_name和Drug_claim_primary_name提出来，
#和"/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model_both/Gene-based_drug_R_or_S_optimization/huan_data/output/023_calculate_for_gene_based_repo_logistic_regression_data_final.txt" merge 起来
#得10_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt

perl 11_filter_repo_withdrwal_data_for_logistic_regression.pl ##根据09_prepare_data_for_repo_logistic_regression.txt中的drug cancer pair 在"10_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt"
#中提取repo_or_withdrawl 的logistic_regression信息。得./11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt,
Rscript test_repo_cancer_model.R #用./11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt进行模型预测，并对模型进行评价
Rscript repo_cancer_model.R  #用./11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt进行模型预测，
#并用模型预测"/f/mulinlab/huan/All_result_ICGC/merge_SV_CNV_repurposing_model_both/Gene-based_drug_R_or_S_optimization/huan_data/output/023_calculate_for_gene_based_repo_logistic_regression_data_final.txt"



perl 12_unique_repo_withdrwal_data_for_logistic_regression.pl #把11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt，去掉drug和cancer后去重输出，得12_unique_repo_withdrwal_data_for_logistic_regression.txt