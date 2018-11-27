# 用./output/021_sorted_add_sv_and_cnv_info_for_calculate_feature.txt计算feature, 得./output/03_calculate_for_network_based_repo_logistic_regression_data.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;



# my $f1 = "./12345.txt";
my $f1 = "./output/021_sorted_add_sv_and_cnv_info_for_calculate_feature.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 = "./output/03_calculate_for_network_based_repo_logistic_regression_data.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header="Drug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\taverage_drug_score\taverge_gene_mutation_frequency\taverage_gene_CADD_score\taverage_mutation_map_to_gene_level_score\taverage_path_length\tmin_rwr_normal_P_value\tlogic_true_ratio";
$header = "$header\taverge_gene_num_in_del_hotspot\taverge_gene_num_in_dup_hotspot\taverge_gene_num_in_inv_hotspot\taverge_gene_num_in_tra_hotspot\taverge_gene_num_in_cnv_hotspot";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4,%hash8,%hash10,%hash13,%hash15,%hash16);
my (%hash19,%hash20,%hash21,%hash22,%hash23);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name = $f[1];
        my $drug_entrze = $f[2];
        my $drug_ENSG = $f[3];
        my $drug_target_score = $f[4];
        my $end_entrze = $f[5];
        my $the_shortest_path = $f[6];
        my $path_length = $f[7];
        my $normal_score_P = $f[8];
        my $Mutation_ID = $f[9];
        my $cancer_specific_affected_donors = $f[10];
        my $CADD_MEANPHRED = $f[11];
        my $cancer_ENSG = $f[12];
        my $oncotree_ID_main_tissue =$f[13];
        my $the_final_logic = $f[14];
        my $Map_to_gene_level = $f[15];
        my $map_to_gene_level_score = $f[16];
        my $sv_or_cnv_type = $f[17];
        my $sv_or_cnv_id = $f[18];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID_main_tissue";
        my $v2 = "$cancer_ENSG\t$Mutation_ID\t$cancer_specific_affected_donors";
        my $v4 = "$cancer_ENSG\t$Mutation_ID\t$CADD_MEANPHRED";
        my $v8 = "$cancer_ENSG\t$Mutation_ID\t$map_to_gene_level_score";
        my $v3 = "$the_shortest_path\t$path_length";
        my $v_logic = "$the_shortest_path\t$the_final_logic";
        my $v_sv_cnv = "$cancer_ENSG\t$sv_or_cnv_type\t$sv_or_cnv_id";
        push @{$hash2{$k}},$v2;
        push @{$hash3{$k}},$v3;
        push @{$hash4{$k}},$v4;
        push @{$hash8{$k}},$v8;
        push @{$hash10{$k}},$normal_score_P;
        push @{$hash13{$k}},$cancer_ENSG; #cancer gene 突变个数
        if ($drug_target_score =~/NA/){
            my $v1 = "$drug_ENSG\t1";#没有score，按1处理。
            push @{$hash1{$k}},$v1; 
        }
        else{
            my $v1 = "$drug_ENSG\t$drug_target_score";
            push @{$hash1{$k}},$v1;
        }
        push @{$hash16{$k}},$v_logic; #把所有的logic push进数组
        if ( $the_final_logic =~/true/){#logic true 的push hash15
            push @{$hash15{$k}},$v_logic;  
        }
        #--------------------------------------------------------------把不同的sv 和cnv push进不同的hash 数组
        if($sv_or_cnv_type =~/del_svscore/){ #sv type 为del_svscore
            push @{$hash19{$k}},$v_sv_cnv;
        }
        elsif($sv_or_cnv_type =~/dup_svscore/){ #sv type 为dup_svscore
            push @{$hash20{$k}},$v_sv_cnv;
        }
        else{
            if ($sv_or_cnv_type =~/inv_svscore/){ #sv type 为inv_svscore
                push @{$hash21{$k}},$v_sv_cnv;
            }
            elsif($sv_or_cnv_type =~/tra_svscore/){ #sv type 为tra_svscore
                push @{$hash22{$k}},$v_sv_cnv;
            }
            else{
                if($sv_or_cnv_type =~/cnv_svscore/){ ##sv type 为cnv_svscore
                    push @{$hash23{$k}},$v_sv_cnv;
                }
                # else{ ##sv type 为NA,即不落在任何的cnv或者sv
                #     push @{$hash29{$k}},$$v_sv_cnv;
                # }
                 
            }
        }
    }
}

# #----------------------------------------------------------
foreach my $k (sort keys %hash1){
    my @drug_target_score_infos = @{$hash1{$k}};
    my @cancer_affect_donor_infos = @{$hash2{$k}};
    my @path_length_infos = @{$hash3{$k}};
    my @mutation_pathogenicity_infos = @{$hash4{$k}};
    my @mutation_map_to_gene_level_infos = @{$hash8{$k}};
    my @rwr_normal_score_P_infos = @{$hash10{$k}};
    my @cancer_genes = @{$hash13{$k}};
    my @logic_alls = @{$hash16{$k}};
    my %hash5;
    @drug_target_score_infos = grep { ++$hash5{$_} < 2 } @drug_target_score_infos;
    my %hash6;
    @cancer_affect_donor_infos = grep { ++$hash6{$_} < 2 } @cancer_affect_donor_infos;
    my %hash7;
    @mutation_pathogenicity_infos = grep { ++$hash7{$_} < 2 } @mutation_pathogenicity_infos;
    my %hash9;
    @mutation_map_to_gene_level_infos = grep { ++$hash9{$_} < 2 } @mutation_map_to_gene_level_infos;
    my %hash11;
    @path_length_infos = grep { ++$hash11{$_} < 2 } @path_length_infos;
    my %hash12;
    @rwr_normal_score_P_infos = grep { ++$hash12{$_} < 2 } @rwr_normal_score_P_infos;
    my %hash14;
    @cancer_genes = grep { ++$hash14{$_} < 2 } @cancer_genes;
    my %hash18;
    @logic_alls = grep { ++$hash18{$_} < 2 } @logic_alls;
    

    #------------------------------------------------------计算drug target score（平均，除以drug target基因个数）
    my @score_t=();
    foreach my $v1_t(@drug_target_score_infos){
        my @f1 = split/\t/,$v1_t;
        my $score = $f1[1];
        push @score_t,$score;
    }
    my $drug_target_num_t= @drug_target_score_infos; #
    my $sum_score_t = 0;
    $sum_score_t += $_ foreach @score_t; 
    my $average_score_t = $sum_score_t/$drug_target_num_t;
    #-----------------------------------------------------
    #-----------------------------------------------------------计算logic为true的gene_frequency（平均,除以cancer基因个数）
    my $cancer_gene_num= @cancer_genes;
    my @cancer_specific_affected_donors_trues =();
    foreach my $v2_t(@cancer_affect_donor_infos){
        my @f = split/\t/,$v2_t;
        my $cancer_specific_affected_donors = $f[2];
        push @cancer_specific_affected_donors_trues,$cancer_specific_affected_donors;
    }
    my $sum_gene_f_t =0;  
    $sum_gene_f_t += $_ foreach @cancer_specific_affected_donors_trues; 
    my $averge_gene_f_t = $sum_gene_f_t/$cancer_gene_num;
    #---------------------------------------------------------------------------------
    #------------------------------------------------------------计算gene的致病性分数（平均,除以cancer基因个数）
    my @gene_pathogenicity =();
    foreach my $mutation_pathogenicity_info(@mutation_pathogenicity_infos){
        my @f =split/\t/,$mutation_pathogenicity_info;
        my $mutation_pathogenicity=$f[2];
        push @gene_pathogenicity,$mutation_pathogenicity;
    }
    my $sum_gene_p = 0;
    $sum_gene_p += $_ foreach @gene_pathogenicity;
    my $averge_gene_p = $sum_gene_p/$cancer_gene_num;
    #----------------------------------------------------------------
    #---------------------------------------------------------------计算mutation map to gene level score (平均，除以突变个数)
    my @mutation_map_to_gene_level = ();
    my $mutation_num = @mutation_map_to_gene_level_infos;
    foreach my $mutation_map_to_gene_level_info(@mutation_map_to_gene_level_infos){
        my @f =split/\t/,$mutation_map_to_gene_level_info;
        my $mutation_map_to_gene_level_score=$f[2];
        push @mutation_map_to_gene_level,$mutation_map_to_gene_level_score;
    }
    my $sum_mutation_map_to_gene_level_score = 0;
    $sum_mutation_map_to_gene_level_score += $_ foreach @mutation_map_to_gene_level;
    my $averge_mutation_map_to_gene_level_score = $sum_mutation_map_to_gene_level_score/$mutation_num;
    #----------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------------------计算 drug target 和cancer gene 网络中的平均最短路径(平均，除以最短路径个数)
    my @path_length_array=();
    my $path_number = @path_length_infos;
    foreach my $path_length_info(@path_length_infos){
        my @f =split/\t/,$path_length_info;
        my $path_length = $f[1];
        push @path_length_array,$path_length;
    }
    my $sum_path_length = 0;
    $sum_path_length += $_ foreach @path_length_array;
    my $average_path_length = $sum_path_length/$path_number;
    #--------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------------------------寻找最小的p值
    my $min_rwr_normal_P_value = min @rwr_normal_score_P_infos;
    #--------------------------------------------------------------------------
    #-----------------------------------------------------------------------------------------------------计算logic true ratio 并将要输出的部分结果push进数组
    my $logic_all = @logic_alls;
    my @outputs= ();
    if (exists $hash15{$k}){
        my @logic_trues = @{$hash15{$k}};
        my %hash17;
        @logic_trues = grep { ++$hash17{$_} < 2 } @logic_trues;
        my $logic_true_num = @logic_trues;
        my $logic_true_ratio = $logic_true_num/$logic_all;
        my $output = "$k\t$average_score_t\t$averge_gene_f_t\t$averge_gene_p\t$averge_mutation_map_to_gene_level_score\t$average_path_length\t$min_rwr_normal_P_value\t$logic_true_ratio";
        #print $O1 "$output\n";
        push @outputs,$output;
    }
    else{
        my $logic_true_num = 0;
        my $logic_true_ratio = $logic_true_num/$logic_all;
        my $output = "$k\t$average_score_t\t$averge_gene_f_t\t$averge_gene_p\t$averge_mutation_map_to_gene_level_score\t$average_path_length\t$min_rwr_normal_P_value\t$logic_true_ratio";
        # print $O1 "$output\n";
        push @outputs,$output;
    }
    #--------------------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------计算averge_gene_in_del_hotspot，并push进数组
    if(exists $hash19{$k}){
        my @del_svscores  = @{$hash19{$k}};
        my %hash24;
        @del_svscores = grep { ++$hash24{$_} < 2 } @del_svscores;
        my $del_num = @del_svscores;
        my $averge_gene_num_in_del_hotspot = $del_num/$cancer_gene_num;
        push @outputs,$averge_gene_num_in_del_hotspot;
    }
    else{
        my $averge_gene_num_in_del_hotspot =0;
        push @outputs,$averge_gene_num_in_del_hotspot;
    }
    #----------------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------计算averge_gene_in_dup_hotspot，并push进数组
    if(exists $hash20{$k}){
        my @dup_svscore = @{$hash20{$k}};
        my %hash25;
        @dup_svscore = grep { ++$hash25{$_} < 2 } @dup_svscore;
        my $dup_num = @dup_svscore;
        my $averge_gene_num_in_dup = $dup_num/$cancer_gene_num;
        push @outputs, $averge_gene_num_in_dup;
    }
    else{
        my $averge_gene_num_in_dup =0;
        push @outputs, $averge_gene_num_in_dup;
    }
    #----------------------------------------------------------------------------------------------
    #-------------------------------------------------------------------------------------------------计算averge_gene_num_in_inv，并push进数组
    if(exists $hash21{$k}){
        my @inv_svscore = @{$hash21{$k}};
        my %hash26;
        @inv_svscore = grep { ++$hash26{$_} < 2 } @inv_svscore;
        my $inv_num = @inv_svscore;
        my $averge_gene_num_in_inv = $inv_num/$cancer_gene_num;
        push @outputs, $averge_gene_num_in_inv;
    }
    else{
        my $averge_gene_num_in_inv =0;
        push @outputs, $averge_gene_num_in_inv;
    }
    #------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------------------计算averge_gene_num_in_tra，并push进数组
    if(exists $hash22{$k}){
        my @tra_svscore = @{$hash22{$k}};
        my %hash27;
        @tra_svscore = grep { ++$hash27{$_} < 2 } @tra_svscore;
        my $tra_num = @tra_svscore;
        my $averge_gene_num_in_tra = $tra_num/$cancer_gene_num;
        push @outputs, $averge_gene_num_in_tra;
    }
    else{
        my $averge_gene_num_in_tra = 0;
        push @outputs, $averge_gene_num_in_tra;
    }
    #--------------------------------------------------------------------------------
    #---------------------------------------------------------------------------------------计算averge_gene_num_in_cnv，并push进数组
    if(exists $hash23{$k}){
        my @cnv_svscore = @{$hash23{$k}};
        my %hash28;
        @cnv_svscore = grep { ++$hash28{$_} < 2 } @cnv_svscore;
        my $cnv_num = @cnv_svscore;
        my $averge_gene_num_in_cnv = $cnv_num/$cancer_gene_num;
        push @outputs, $averge_gene_num_in_cnv;
    }
    else{
        my $averge_gene_num_in_cnv = 0;
        push @outputs, $averge_gene_num_in_cnv;
    }

    my $final_output = join("\t",@outputs);
    print $O1 "$final_output\n";
}

