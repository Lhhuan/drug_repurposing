#用01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt输出用于计算出logistic_regression需要的data的数据，02_data_used_calculate_for_repo_logistic_regression.txt
#并得计算02_calculate_for_repo_logistic_regression_data.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt";
my $fo1 = "./02_data_used_calculate_for_repo_logistic_regression.txt";
my $fo2 = "./02_calculate_for_repo_logistic_regression_data.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O1 "Drug_chembl_id|Drug_claim_primary_name\tensg\tdrug_target_score\tcancer_oncotree_main_id\tmutation_id\tMap_to_gene_level\tcancer_specific_affected_donors\tCADD_MEANPHRED\tlogic\tmap_to_gene_level_score\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^CADD_MEANPHRED/){
        my @f =split/\t/;
        my $CADD_MEANPHRED = $f[0];
        my $drug_target_score = $f[1];
        my $mutation_id = $f[2];
        my $map_to_gene_level = $f[3];
        my $cancer_specific_affected_donors = $f[6];
        my $cancer_oncotree_main_id = $f[13];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[15];
        my $ensg = $f[29];
        my $logic = $f[-1];
        my $output1 = "$Drug_chembl_id_Drug_claim_primary_name\t$ensg\t$drug_target_score\t$cancer_oncotree_main_id\t$mutation_id\t$map_to_gene_level\t$cancer_specific_affected_donors\t$CADD_MEANPHRED\t$logic";
        if($map_to_gene_level=~/Level1_protein_coding/){ #Level1_protein_coding 给score 为5
            print $O1 "$output1\t5\n";
        }
        elsif($map_to_gene_level=~/level2_enhancer_target/){ #level2_enhancer_target 给score 为3
            print $O1 "$output1\t3\n";
        }
        else{
            if($map_to_gene_level=~/level3.1/){ #level3.1 给score 为2
                print $O1 "$output1\t2\n";
            }
            elsif($map_to_gene_level=~/level3.2/){ #level3.2 给score 为1
                print $O1 "$output1\t1\n";
            }
        }
        
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

my $f2 = "./02_data_used_calculate_for_repo_logistic_regression.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
print $O2 "Drug\tcancer_oncotree_main_id\taverage_drug_score\taverge_gene_mutation_frequency\taverage_gene_CADD_score\taverage_mutation_map_to_gene_level_score\n";
my (%hash1,%hash2,%hash3,%hash4,%hash8);

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_claim_primary_name = $f[0];
        my $ensg = $f[1];
        my $drug_target_score = $f[2];
        my $cancer_oncotree_main_id = $f[3];
        my $mutation_id = $f[4];
        my $Map_to_gene_level = $f[5];
        my $cancer_specific_affected_donors = $f[6];
        my $CADD_MEANPHRED = $f[7];
        my $logic = $f[8];
        my $map_to_gene_level_score = $f[-1];
        my $k = "$Drug_claim_primary_name\t$cancer_oncotree_main_id";
        my $v2 = "$ensg\t$mutation_id\t$cancer_specific_affected_donors";
        my $v4 = "$ensg\t$mutation_id\t$CADD_MEANPHRED";
        my $v8 = "$ensg\t$mutation_id\t$map_to_gene_level_score";
        if ($drug_target_score =~/NA/){
            my $v1 = "$ensg\t1";#没有score，按1处理。
            if($logic =~/true/){ #为drug repo 建模型，只考虑
                push @{$hash1{$k}},$v1; 
                push @{$hash2{$k}},$v2;
                push @{$hash4{$k}},$v4;
                push @{$hash8{$k}},$v8;
            }
        }
        else{
            my $v1 = "$ensg\t$drug_target_score";
            if($logic =~/true/){ #为drug repo 建模型，只考虑
                push @{$hash1{$k}},$v1; 
                push @{$hash2{$k}},$v2;
                push @{$hash4{$k}},$v4;
                push @{$hash8{$k}},$v8;
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
    my $output = "$k\t$average_score_t\t$averge_gene_f_t\t$averge_gene_p\t$averge_mutation_map_to_gene_level_score";
    print $O2 "$output\n";

}



