
#用./output/021_sorted_add_CNV_dup_del_info_for_calculate_feature.txt计算得用于逻辑回归模型预测的文件"./output/022_calculate_for_repo_logistic_regression_CNV_dup_del_data.txt"

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

# my $f2 = "./123_test.txt";
my $f2 = "./output/021_sorted_add_CNV_dup_del_info_for_calculate_feature.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo2 = "./output/022_calculate_for_repo_logistic_regression_CNV_dup_del_data.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header= "Drug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\taverage_drug_score\taverge_gene_mutation_frequency\taverage_gene_CADD_score\taverage_mutation_map_to_gene_level_score";
$header = "$header\taverge_gene_num_in_del_hotspot\taverge_gene_num_in_dup_hotspot\taverge_gene_num_in_cnv_hotspot";
print $O2 "$header\n";
my (%hash1,%hash2,%hash3,%hash4,%hash8);
my (%hash19,%hash20,%hash21,%hash22,%hash23);
while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $ensg = $f[1];
        my $drug_target_score = $f[2];
        my $cancer_oncotree_main_id = $f[3];
        my $mutation_id = $f[4];
        my $Map_to_gene_level = $f[5];
        my $cancer_specific_affected_donors = $f[6];
        my $CADD_MEANPHRED = $f[7];
        my $logic = $f[8];
        my $map_to_gene_level_score = $f[9];
        my $sv_or_cnv_type = $f[10];
        my $sv_or_cnv_id = $f[11];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_main_id";
        my $v2 = "$ensg\t$mutation_id\t$cancer_specific_affected_donors";
        my $v4 = "$ensg\t$mutation_id\t$CADD_MEANPHRED";
        my $v8 = "$ensg\t$mutation_id\t$map_to_gene_level_score";
        my $v_sv_cnv = "$ensg\t$sv_or_cnv_type\t$sv_or_cnv_id";
        if ($logic =~/true/){ #为drug repo 建模型，只考虑true
            push @{$hash2{$k}},$v2;
            push @{$hash4{$k}},$v4;
            push @{$hash8{$k}},$v8;
            if ($drug_target_score =~/NA/){
                my $v1 = "$ensg\t1";#没有score，按1处理。
                push @{$hash1{$k}},$v1;
            }
            else{
                my $v1 = "$ensg\t$drug_target_score";
                push @{$hash1{$k}},$v1;
            }
            #--------------------------------------------------------------把不同的sv 和cnv push进不同的hash 数组
            if($sv_or_cnv_type =~/del_svscore/){ #sv type 为del_svscore
                push @{$hash19{$k}},$v_sv_cnv;
            }
            elsif($sv_or_cnv_type =~/dup_svscore/){ #sv type 为dup_svscore
                push @{$hash20{$k}},$v_sv_cnv;
            }
            else{
                if($sv_or_cnv_type =~/cnv_svscore/){ ##sv type 为cnv_svscore
                        push @{$hash23{$k}},$v_sv_cnv;
                }
            }

        }
    }
}

# #----------------------------------------------------------
foreach my $k (sort keys %hash1){
    my @drug_target_score_infos = @{$hash1{$k}};
    my @cancer_affect_donor_infos = @{$hash2{$k}};
    my @mutation_pathogenicity_infos = @{$hash4{$k}};
    my @mutation_map_to_gene_level_infos = @{$hash8{$k}};
    my %hash5;
    @drug_target_score_infos = grep { ++$hash5{$_} < 2 } @drug_target_score_infos;
    my %hash6;
    @cancer_affect_donor_infos = grep { ++$hash6{$_} < 2 } @cancer_affect_donor_infos;
    my %hash7;
    @mutation_pathogenicity_infos = grep { ++$hash7{$_} < 2 } @mutation_pathogenicity_infos;
    my %hash9;
    @mutation_map_to_gene_level_infos = grep { ++$hash9{$_} < 2 } @mutation_map_to_gene_level_infos;
    #------------------------------------------------------计算drug target score（平均，除以基因个数）
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
    #-----------------------------------------------------------计算logic为true的gene_frequency（平均,除以基因个数）
    my @cancer_specific_affected_donors_trues =();
    foreach my $v2_t(@cancer_affect_donor_infos){
        my @f = split/\t/,$v2_t;
        my $cancer_specific_affected_donors = $f[2];
        push @cancer_specific_affected_donors_trues,$cancer_specific_affected_donors;
    }
    my $sum_gene_f_t =0;  
    $sum_gene_f_t += $_ foreach @cancer_specific_affected_donors_trues; 
    my $averge_gene_f_t = $sum_gene_f_t/$drug_target_num_t;
    #---------------------------------------------------------------------------------
    #------------------------------------------------------------计算gene的致病性分数（平均,除以基因个数）
    my @gene_pathogenicity =();
    foreach my $mutation_pathogenicity_info(@mutation_pathogenicity_infos){
        my @f =split/\t/,$mutation_pathogenicity_info;
        my $mutation_pathogenicity=$f[2];
        push @gene_pathogenicity,$mutation_pathogenicity;
    }
    my $sum_gene_p = 0;
    $sum_gene_p += $_ foreach @gene_pathogenicity;
    my $averge_gene_p = $sum_gene_p/$drug_target_num_t;
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
    my @outputs= ();
    my $output = "$k\t$average_score_t\t$averge_gene_f_t\t$averge_gene_p\t$averge_mutation_map_to_gene_level_score";
    push @outputs,$output;

    my $cancer_gene_num= $drug_target_num_t;

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
    print $O2 "$final_output\n";

}



