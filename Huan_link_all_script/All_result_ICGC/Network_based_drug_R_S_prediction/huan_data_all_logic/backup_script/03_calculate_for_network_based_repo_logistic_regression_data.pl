# 用./output/02_filter_infos_for_calculate_feature.txt计算feature, 得./output/03_calculate_for_network_based_repo_logistic_regression_data.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;
system "sort ./output/02_filter_infos_for_calculate_feature.txt | uniq >./output/unique_02_filter_infos_for_calculate_feature.txt" ; #暂时注释


my $f1 = "./output/unique_02_filter_infos_for_calculate_feature.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 = "./output/03_calculate_for_network_based_repo_logistic_regression_data.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Drug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\taverage_drug_score\taverge_gene_mutation_frequency\taverage_gene_CADD_score\taverage_mutation_map_to_gene_level_score\taverage_path_length\tmin_rwr_normal_P_value\n";
my (%hash1,%hash2,%hash3,%hash4,%hash8,%hash10,%hash13);

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
        my $Map_to_gene_level = $f[14];
        my $map_to_gene_level_score = $f[15];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID_main_tissue";
        my $v2 = "$cancer_ENSG\t$Mutation_ID\t$cancer_specific_affected_donors";
        my $v4 = "$cancer_ENSG\t$Mutation_ID\t$CADD_MEANPHRED";
        my $v8 = "$cancer_ENSG\t$Mutation_ID\t$map_to_gene_level_score";
        my $v3 = "$the_shortest_path\t$path_length";
        push @{$hash2{$k}},$v2;
        push @{$hash3{$k}},$v3;
        push @{$hash4{$k}},$v4;
        push @{$hash8{$k}},$v8;
        push @{$hash10{$k}},$normal_score_P;
        push @{$hash13{$k}},$cancer_ENSG; #cancer gene 突变个数
        if ($drug_target_score =~/NA|NONE/){
            my $v1 = "$drug_ENSG\t1";#没有score，按1处理。
            push @{$hash1{$k}},$v1; 
        }
        else{
            my $v1 = "$drug_ENSG\t$drug_target_score";
            push @{$hash1{$k}},$v1;
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
    #---------------------------------------------------------------------输出结果
    my $output = "$k\t$average_score_t\t$averge_gene_f_t\t$averge_gene_p\t$averge_mutation_map_to_gene_level_score\t$average_path_length\t$min_rwr_normal_P_value";
    print $O1 "$output\n";

}



