#用08_sorted_logic_not_no_drug_cancer_infos_check.txt为做逻辑回归准备数据，得文件09_prepare_data_for_logistic_regression.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./08_sorted_logic_not_no_drug_cancer_infos_check.txt";
my $fo1 ="./09_prepare_data_for_logistic_regression.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Drug_claim_primary_name\toncotree_main_ID\trepo_or_side_effect\taverage_score_logic_true\taverge_gene_frequency_logic_true\taverage_score_c\taverge_gene_f_c\n";
my (%hash1,%hash2,%hash3);
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
        my $cancer_specific_affected_donors = $f[7];
        my $logic = $f[-1];
        my $k = "$Drug_claim_primary_name\t$oncotree_main_ID";
        my $v1 = "$Entrez_id\t$ensg\t$normal_drug_target_score";
        my $v2 = "$Entrez_id\t$ensg\t$mutation_id\t$cancer_specific_affected_donors";
         $hash3{$k}= $repo_or_side_effect;
        if($logic =~/true/){ #logic true和conflict分开计算
            push @{$hash1{$k}->{logic_true} },$v1; 
            push @{$hash2{$k}->{logic_true} },$v2; #哈希的哈希 一个哈希的键可能会有多个值，这个值可能会是下一组哈希键值对的键，所以以第一个哈希的值作为键，将其对应的值push到数组中(logic_true是名为$hash2{$k}的哈希的k，$cancer_specific_affected_donors为值)
        }
        else{
            push @{$hash1{$k}->{logic_conflict} },$v1; 
            push @{$hash2{$k}->{logic_conflict} },$v2;
        }
    }
}


my (%hash8,%hash9);
foreach my $k (sort keys %hash1){
    if (exists $hash2{$k}){
        foreach my $logic ( sort keys %{$hash1{$k}} ) { #取名为$hash1{$k} 的哈希的值
            if ($logic eq "logic_true" ){ #---------------------------------------------------------------------------------------------------------------------logic为true的
                my @v1_ts = @{$hash1{$k}->{logic_true}}; ##@{$hash1{$k}->{logic_true}}的意思是取 名为$hash1{$k}的哈希，，取logic_true为键的对应的值，（哈希的哈希）
                my @v2_ts = @{$hash2{$k}->{logic_true} };
                my %hash4;
                @v1_ts = grep { ++$hash4{$_} < 2 } @v1_ts;
                my %hash6;
                @v2_ts = grep { ++$hash6{$_} < 2 } @v2_ts;#对数组进行去重
                #----------------------------------------------------------------计算logic为true的drug target score
                my @score_t=();
                foreach my $v1_t(@v1_ts){
                    my @f1 = split/\t/,$v1_t;
                    my $score = $f1[2];
                    push @score_t,$score;
                }
                my $drug_target_num_t= @v1_ts;
                my $sum_score_t = 0;
                $sum_score_t += $_ foreach @score_t; 
                my $average_score_t = $sum_score_t/$drug_target_num_t;
                #--------------------------------------------------------------------------
                #------------------------------------------------------------------------------------计算logic为true的gene_frequency
                my @cancer_specific_affected_donors_trues =();
                foreach my $v2_t(@v2_ts){
                    my @f = split/\t/,$v2_t;
                    my $cancer_specific_affected_donors = $f[3];
                    push @cancer_specific_affected_donors_trues,$cancer_specific_affected_donors;
                }
                my $sum_gene_f_t =0;  
                $sum_gene_f_t += $_ foreach @cancer_specific_affected_donors_trues; 
                my $averge_gene_f_t = $sum_gene_f_t/$drug_target_num_t;
                #------------------------------------------------------------------
                my $v_logic_true = "$average_score_t\t$averge_gene_f_t";
                $hash8{$k} = $v_logic_true;
            }
            else{#---------------------------------------------------------------------logic 为conflict
                my @v1_cs = @{$hash1{$k}->{logic_conflict}};
                my @v2_cs = @{$hash2{$k}->{logic_conflict}};
                my %hash5;
                @v1_cs = grep { ++$hash5{$_} < 2 } @v1_cs;
                my %hash7;
                @v2_cs = grep { ++$hash7{$_} < 2 }  @v2_cs;
                #-----------------------------------------------
                #-----------------------------------计算logic为confilict的drug target score
                my $drug_target_num_c= @v1_cs;
                my @score_c=();
                foreach my $v1_c(@v1_cs){
                    my @f1 = split/\t/,$v1_c;
                    my $score = $f1[2];
                    push @score_c,$score;
                }
                my $sum_score_c = 0;
                $sum_score_c += $_ foreach @score_c; 
                my $average_score_c = $sum_score_c/$drug_target_num_c;
                #----------------------------------------------------------------------------------------
                #-----------------------------------计算logic为confilct的gene_frequency
                my @cancer_specific_affected_donors_conflicts =();
                foreach my $v2_c(@v2_cs){
                    my @f = split/\t/,$v2_c;
                    my $cancer_specific_affected_donors = $f[3];
                    push @cancer_specific_affected_donors_conflicts,$cancer_specific_affected_donors;
                }
                my $sum_gene_f_c =0;  
                $sum_gene_f_c += $_ foreach @cancer_specific_affected_donors_conflicts; 
                my $averge_gene_f_c = $sum_gene_f_c /$drug_target_num_c;
                #-----------------------------------------------------
                my $v_logic_conflict= "$average_score_c\t$averge_gene_f_c";
                $hash9{$k}= $v_logic_conflict;
            }
        }
    }
}

my %hash10;
foreach my $k(sort keys %hash3){
    my $repo_or_side_effect = $hash3{$k};
    if (exists $hash8{$k}){
        my $v_logic_true = $hash8{$k};
        if (exists $hash9{$k}){
            my $v_logic_conflict = $hash9{$k};
            my $output1 = "$k\t$repo_or_side_effect\t$v_logic_true\t$v_logic_conflict";
            unless(exists $hash10{$output1}){
                $hash10{$output1} =1;
                print $O1 "$output1\n";
            }
        }
        else{
            my $output1 = "$k\t$repo_or_side_effect\t$v_logic_true\t0\t0";
            unless(exists $hash10{$output1}){
                $hash10{$output1} =1;
                print $O1 "$output1\n";
            }
        }
    }
    elsif(exists $hash9{$k}){
        my $v_logic_conflict = $hash9{$k};
        unless(exists $hash8{$k}){
            my $output1 = "$k\t$repo_or_side_effect\t0\t0\t$v_logic_conflict";
            unless(exists $hash10{$output1}){
                $hash10{$output1} =1;
                print $O1 "$output1\n";
            }
        }
    }
}





