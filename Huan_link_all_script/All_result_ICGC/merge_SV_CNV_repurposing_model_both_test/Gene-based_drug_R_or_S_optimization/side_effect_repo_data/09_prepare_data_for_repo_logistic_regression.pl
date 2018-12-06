#用08_sorted_logic_not_no_drug_cancer_infos_check.txt为做drug repo 逻辑回归准备数据，得文件09_prepare_data_for_repo_logistic_regression.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

system "cat 08_logic_not_no_drug_cancer_infos_check.txt | sort -k1,1V -k5,5V> 08_sorted_logic_not_no_drug_cancer_infos_check.txt";
my $f1 ="./08_sorted_logic_not_no_drug_cancer_infos_check.txt";
my $fo1 ="./09_prepare_data_for_repo_logistic_regression.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Drug_claim_primary_name\toncotree_main_ID\taverage_drug_score\taverge_gene_mutation_frequency\taverage_gene_CADD_score\taverage_mutation_map_to_gene_level_score\tdrug_cancer_type\tdrug_repurposing\n";
my (%hash1,%hash2,%hash3,%hash4,%hash8);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug_claim_primary_name = $f[0];
        my $Entrez_id = $f[1];
        my $ensg = $f[2];
        my $normal_drug_target_score = $f[3];
        my $oncotree_main_ID = $f[4];
        my $repo_or_side_effect = $f[5];
        my $mutation_id = $f[6];
        my $CADD_score = $f[7];
        my $map_to_gene_level = $f[8];
        my $cancer_specific_affected_donors = $f[9];
        my $logic = $f[10];
        my $map_to_gene_level_score = $f[-1];
        #print STDERR "$map_to_gene_level_score\n";
        my $k = "$Drug_claim_primary_name\t$oncotree_main_ID";
        my $v1 = "$Entrez_id\t$ensg\t$normal_drug_target_score";
        my $v2 = "$Entrez_id\t$ensg\t$mutation_id\t$cancer_specific_affected_donors";
        my $v4 = "$Entrez_id\t$ensg\t$mutation_id\t$CADD_score";
        my $v8 = "$Entrez_id\t$ensg\t$mutation_id\t$map_to_gene_level_score";
        #if($repo_or_side_effect=~/Drug_repo|Withdrawn|No_function/){
        if($repo_or_side_effect=~/Drug_repo|Withdrawn|Indication|Terminated/){
            #print STDERR "$_\n";
            if($logic =~/true/){ #为drug repo 建模型，只考虑
                push @{$hash1{$k}},$v1;
                push @{$hash2{$k}},$v2;
                push @{$hash4{$k}},$v4;
                push @{$hash8{$k}},$v8;
               $hash3{$k}= $repo_or_side_effect;
            }
        }
    }
}

#----------------------------------------------------------
foreach my $k (sort keys %hash1){
    my @drug_target_score_infos = @{$hash1{$k}};
    my @cancer_affect_donor_infos = @{$hash2{$k}};
    my @mutation_pathogenicity_infos = @{$hash4{$k}};
    my @mutation_map_to_gene_level_infos = @{$hash8{$k}};
    my $repo_or_side_effect = $hash3{$k};
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
        my $score = $f1[2];
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
        my $cancer_specific_affected_donors = $f[3];
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
        my $mutation_pathogenicity=$f[3];
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
        my $mutation_map_to_gene_level_score=$f[3];
        push @mutation_map_to_gene_level,$mutation_map_to_gene_level_score;
    }
    my $sum_mutation_map_to_gene_level_score = 0;
    $sum_mutation_map_to_gene_level_score += $_ foreach @mutation_map_to_gene_level;
    my $averge_mutation_map_to_gene_level_score = $sum_mutation_map_to_gene_level_score/$mutation_num;
    #----------------------------------------------------------------------------
    my $output = "$k\t$average_score_t\t$averge_gene_f_t\t$averge_gene_p\t$averge_mutation_map_to_gene_level_score\t$repo_or_side_effect";
    if($repo_or_side_effect =~/Drug_repo|Indication/){
        print $O1 "$output\t1\n";
    }
    else{
        print $O1 "$output\t0\n";
    }

}
#-----------------------------------------------------------

