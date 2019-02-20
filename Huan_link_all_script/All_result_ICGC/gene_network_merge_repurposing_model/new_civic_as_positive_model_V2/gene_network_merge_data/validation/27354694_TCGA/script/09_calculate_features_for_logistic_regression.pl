#用../output/07_filter_snv_in_huan.txt 和../output/08_filter_cnv_in_huan.txt 计算用于用于model预测的feature ,得../output/09_calculate_features_for_logistic_regression.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;

# my $f1 = "./snv_test_c.txt";
# open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# my $f2 = "./cnv_test_c.txt";
# open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f1 = "../output/07_filter_snv_in_huan.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "../output/08_filter_cnv_in_huan.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "../output/09_calculate_features_for_logistic_regression.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_in_paper\toncotree_id\toncotree_id_type\tpaper_sample_name";
$header="$header\taverage_effective_drug_target_score\taverage_mutation_frequency";
$header ="$header\taverage_mutation_pathogenicity\taverage_mutation_map_to_gene_level_score\taverage_the_shortest_path_length\tmin_rwr_normal_P_value\tmedian_rwr_normal_P_value";
$header = "$header\tcancer_gene_exact_match_drug_target_ratio\taverage_del_svscore\taverage_dup_svscore\taverage_inv_svscore\taverage_tra_svscore\taverage_cnv_svscore";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30,%hash32);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $oncotree_id = $f[1];
        my $Mutation_ID = $f[2];
        my $drug_entrze = $f[3];
        my $drug_ENSG = $f[4];
        my $drug_target_score = $f[5];
        my $end_entrze = $f[6];
        my $the_shortest_path = $f[7];
        my $path_length = $f[8];
        my $normal_score_P = $f[9];
        
        my $cancer_specific_affected_donors = $f[11];
        my $original_cancer_ID = $f[12];
        #--------------------------------------------
        my $CADD_MEANPHRED = $f[13];
        my $cancer_ENSG = $f[14];
        my $the_final_logic = $f[15];
        my $Map_to_gene_level = $f[16];
        my $map_to_gene_level_score = $f[17];
        my $data_source = $f[18];
        my $oncotree_id_type = $f[19];
        my $drug_in_paper = $f[20];
        my $paper_sample_name = $f[21];

        # my $drug_all_target_number =$f[19];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$drug_in_paper\t$oncotree_id\t$oncotree_id_type\t$paper_sample_name";
        my $v2 = "$Mutation_ID\t$cancer_specific_affected_donors\t$original_cancer_ID";
        my $v4 = "$Mutation_ID\t$CADD_MEANPHRED";
        my $v5 = "$Mutation_ID\t$map_to_gene_level_score";
        my $v3 = "$the_shortest_path\t$path_length";
        push @{$hash2{$k}},$v2;
        push @{$hash3{$k}},$v3;
        push @{$hash4{$k}},$v4;
        push @{$hash5{$k}},$v5;
        push @{$hash6{$k}},$normal_score_P;
        push @{$hash30{$k}},$cancer_ENSG; #all_cancer genes
        #-----------------------------------------------
        #-----------------------------------------------push drug target score
        if ($drug_target_score =~/NA/){
            my $v1 = "$drug_ENSG\t1";#没有score，按1处理。
            push @{$hash1{$k}},$v1; 
        }
        else{
            my $v1 = "$drug_ENSG\t$drug_target_score";
            push @{$hash1{$k}},$v1;
        }
        #---------------------------------------------------------- #把cancer gene 和drug target 直接match的push进数组。

        if ($data_source =~/gene_based/){
            push @{$hash7{$k}},$cancer_ENSG; # exact match cancer gene 个数
            # $hash13{$k}=$drug_all_target_number;
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#CHROM/){
        my @f =split/\t/;
        my $paper_sample_name = $f[0];
        my $SVSCORETOP10 = $f[5];
        my $SVTYPE =$f[9];
        my $sv_or_cnv_type = $f[10];
        my $sv_or_cnv_id  =$f[11];
        my $oncotree_ID = $f[12];
        my $oncotree_ID_type = $f[13];
        #--------------------------------------------------------------把cnv push进hash 数组
        my $k = "$paper_sample_name\t$oncotree_ID\t$oncotree_ID_type";
        my $v = "$sv_or_cnv_id\t$SVSCORETOP10";
        # print STDERR "$v\n";
        push @{$hash12{$k}},$v;
    }
}


foreach my $k (sort keys %hash1){
    #-------------------------------------------------计算 average drug target score (除以有效的drug target number)
    my @drug_target_score_infos = @{$hash1{$k}};
    my %hash14;
    @drug_target_score_infos = grep { ++$hash14{$_} < 2 } @drug_target_score_infos; #对数组内元素去重
    my @score_t=();
    foreach my $v1_t(@drug_target_score_infos){
        my @f1 = split/\t/,$v1_t;
        my $score = $f1[1];
        push @score_t,$score;
    }
    my $drug_target_num= @drug_target_score_infos; #
    my $sum_score_t = sum @score_t; 
    my $average_effective_drug_target_score = $sum_score_t/$drug_target_num;
    #---------------------------------------------------计算 average mutation frequency (除以mutation number)
    my @cancer_affect_donor_infos = @{$hash2{$k}};
    my %hash15;
    @cancer_affect_donor_infos = grep { ++$hash15{$_} < 2 } @cancer_affect_donor_infos;
    my @cancer_specific_affected_donors =();
    my @cancer_specific_mutation = ();
    foreach my $v2_t(@cancer_affect_donor_infos){
        my @f = split/\t/,$v2_t;
        my $mutation_id = $f[0];
        my $cancer_specific_affected_donors = $f[1];
        push @cancer_specific_mutation,$mutation_id;#因为同一mutation 会对应同一main cancer typex下的sub cancer type,所以会出现一个mutation 对应同一个main cancer type 会出现多个不同的cancer_specific_affected_donors，所以把单独看mutation的个数
        push @cancer_specific_affected_donors,$cancer_specific_affected_donors; 
    } 
    my $sum_mutation_f =sum @cancer_specific_affected_donors; 
    my %hash26;
    @cancer_specific_mutation = grep { ++$hash26{$_} < 2 } @cancer_specific_mutation;
    my $mutation_num = @cancer_specific_mutation;
    my $averge_mutation_frequency = $sum_mutation_f/$mutation_num;   
    #-------------------------------------------------------------#计算 average mutation pathogenicity score (除以mutation number)
    my @mutation_pathogenicity_infos = @{$hash4{$k}};
    my %hash16;
    @mutation_pathogenicity_infos = grep { ++$hash16{$_} < 2 } @mutation_pathogenicity_infos;
    my @gene_pathogenicity =();
    my $mutation_num2 = @mutation_pathogenicity_infos;#$mutation_num2理论上是等于$mutation_num，为了避免出错，再写一次
    foreach my $mutation_pathogenicity_info(@mutation_pathogenicity_infos){
        my @f =split/\t/,$mutation_pathogenicity_info;
        my $mutation_pathogenicity=$f[1];
        push @gene_pathogenicity,$mutation_pathogenicity;
    }
    my $sum_mutation_p = sum @gene_pathogenicity;
    my $averge_mutation_pathogenicity = $sum_mutation_p/$mutation_num2;
    #------------------------------------------------------------------- #计算 average map_to_gene_level_score (除以mutation number)
    my @mutation_map_to_gene_level_infos = @{$hash5{$k}};
    my %hash17;
    @mutation_map_to_gene_level_infos = grep { ++$hash17{$_} < 2 } @mutation_map_to_gene_level_infos;
    my @mutation_map_to_gene_level = ();
    my $mutation_num3 = @mutation_map_to_gene_level_infos;  #$mutation_num3理论上是等于$mutation_num，为了避免出错，再写一次
    foreach my $mutation_map_to_gene_level_info(@mutation_map_to_gene_level_infos){
        my @f =split/\t/,$mutation_map_to_gene_level_info;
        my $mutation_map_to_gene_level_score=$f[1];
        push @mutation_map_to_gene_level,$mutation_map_to_gene_level_score;
    }
    my $sum_mutation_map_to_gene_level_score = sum @mutation_map_to_gene_level;
    my $averge_mutation_map_to_gene_level_score = $sum_mutation_map_to_gene_level_score/$mutation_num3;
    #-----------------------------------------------------------------------------#计算average the shortest path length of drug target to cancer gene(除以 path number)
    my @path_length_infos = @{$hash3{$k}};
    my %hash18;
    @path_length_infos = grep { ++$hash18{$_} < 2 } @path_length_infos;
    my @path_length_array=();
    my $path_number = @path_length_infos;
    foreach my $path_length_info(@path_length_infos){
        my @f =split/\t/,$path_length_info;
        my $path_length = $f[1];
        push @path_length_array,$path_length;
    }
    my $sum_path_length = sum @path_length_array;
    my $average_path_length = $sum_path_length/$path_number;
    #-------------------------------------------------------------------------- #计算min normal P 和 median p
    my @rwr_normal_score_P_infos = @{$hash6{$k}};
    my %hash19;
    @rwr_normal_score_P_infos = grep { ++$hash19{$_} < 2 } @rwr_normal_score_P_infos;
    my $min_rwr_normal_P_value = min @rwr_normal_score_P_infos;
    #--------------------------------------计算median p
    my $median_rwr_normal_P_value = mid(@rwr_normal_score_P_infos); #把@rwr_normal_score_P_infos传递给子程序
    sub mid{
        my @list = sort{$a<=>$b} @_;
        my $count = @list;
        if( $count == 0 )
        {
            return undef;
        }   
        if(($count%2)==1){
            return $list[int(($count-1)/2)];
        }
        elsif(($count%2)==0){
            return ($list[int(($count-1)/2)]+$list[int(($count)/2)])/2;
        }
    }
    my @outputs = ();
    my $output1 = "$average_effective_drug_target_score\t$averge_mutation_frequency\t$averge_mutation_pathogenicity\t$averge_mutation_map_to_gene_level_score";
    $output1 = "$output1\t$average_path_length\t$min_rwr_normal_P_value\t$median_rwr_normal_P_value";
    push @outputs,$output1;
    #-------------------------------------------------------------------------#计算exact match cancer gene 和all cancer gene
    if (exists $hash7{$k}){
        my @cancer_ensgs =  @{$hash7{$k}};
        # my $drug_all_target_number = $hash13{$k};
        my @all_cancer_genes = @{$hash30{$k}};
        my %hash20;
        @cancer_ensgs = grep { ++$hash20{$_} < 2 } @cancer_ensgs;
        my %hash31;
        @all_cancer_genes =grep { ++$hash31{$_} < 2 } @all_cancer_genes;
        my $cancer_gene_exact_match_drug_target_number = @cancer_ensgs;
        my $all_cancer_gene_num = @all_cancer_genes;
        my $cancer_gene_exact_match_drug_target_ratio = $cancer_gene_exact_match_drug_target_number/$all_cancer_gene_num;
        push @outputs,$cancer_gene_exact_match_drug_target_ratio;
    }
    else{
        my $cancer_gene_exact_match_drug_target_ratio = 0;
        push @outputs,$cancer_gene_exact_match_drug_target_ratio;
    }
    #-----------------------------------------------------------------------------
    my @cnvs =();
    my $average_del_svscore =0;
    my $average_dup_svscore =0;
    my $average_inv_svscor =0;
    my $average_tra_svscore =0;
    push @outputs,$average_del_svscore;
    push @outputs,$average_dup_svscore;
    push @outputs,$average_inv_svscor;
    push @outputs,$average_tra_svscore;
    #-------------------------------------------------------------------------------##计算average_cnv_svscore(除以hotspot number)
    my @f = split/\t/,$k;
    my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
    my $drug_in_paper = $f[1];
    my $oncotree_id = $f[2];
    my $oncotree_id_type = $f[3];
    my $paper_sample_name = $f[4];
    my $k_cnv = "$paper_sample_name\t$oncotree_id\t$oncotree_id_type";
    if(exists $hash12{$k_cnv}){
        my @cnv_infos = @{$hash12{$k_cnv}};
        my %hash25;
        @cnv_infos = grep { ++$hash25{$_} < 2 } @cnv_infos;
        my @cnv_svscore= ();
        my $cnv_gene_number = @cnv_infos;
        foreach my $cnv_info(@cnv_infos){
            my @f2 = split/\t/,$cnv_info;
            my $svscore = $f2[1];
            # print STDERR "$cnv_info\n";
            push @cnv_svscore,$svscore;
        }
        my $sum_cnv_svscore = sum @cnv_svscore;
        my $average_cnv_svscore = $sum_cnv_svscore/$cnv_gene_number;
        push @outputs,$average_cnv_svscore;
    }
    else{
        my $average_cnv_svscore =0;
        push @outputs,$average_cnv_svscore;        
    }
    #-------------------------------------------------------------------------------##计输出最后结果
    my $outputs_features = join("\t",@outputs);
    my $final_output = "$k\t$outputs_features";
    print $O1 "$final_output\n";        
}