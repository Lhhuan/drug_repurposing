#用/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/05_merge_all_cnv_sv_project.txt
# 用./output/03_unique_merge_gene_based_and_network_based_data.txt和中的oncotree main tissue ID 计算逻辑回归需要的features，得./output/05_main_calculate_features_for_logistic_regression.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;

# my $f1 = "./03_result_test.txt";
# open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# my $f2 = "./sv_cnv.txt";
# open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f1 = "./output/03_unique_merge_gene_based_and_network_based_data.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/05_merge_all_cnv_sv_project.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/05_main_calculate_features_for_logistic_regression.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header="Drug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\taverage_effective_drug_target_score\taverage_mutation_frequency";
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
        my $drug_entrze = $f[1];
        my $drug_ENSG = $f[2];
        my $drug_target_score = $f[3];
        my $end_entrze = $f[4];
        my $the_shortest_path = $f[5];
        my $path_length = $f[6];
        my $normal_score_P = $f[7];
        my $Mutation_ID = $f[8];
        my $cancer_specific_affected_donors = $f[9];
        my $original_cancer_ID = $f[10];
        #--------------------------------------------
        my $CADD_MEANPHRED = $f[11];
        my $cancer_ENSG = $f[12];
        my $oncotree_ID_sub_tissue =$f[13];
        my $oncotree_ID_main_tissue =$f[14];
        my $the_final_logic = $f[15];
        my $Map_to_gene_level = $f[16];
        my $project = $f[17];
        my $map_to_gene_level_score = $f[18];
        my $data_source = $f[19];
        # my $drug_all_target_number =$f[19];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID_main_tissue";
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
        push @{$hash32{$k}},$project;
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
        my $PROJECT = $f[0];
        my $sv_or_cnv_type = $f[1];
        my $SVTYPE =$f[2];
        my $sv_or_cnv_id  =$f[3];
        my $SVSCORETOP10 = $f[4];
                #--------------------------------------------------------------把不同的sv 和cnv push进不同的hash 数组
        my @projects = split /\,/,$PROJECT;
        foreach my $project (@projects){
            my $v_sv_cnv = "$sv_or_cnv_id\t$SVSCORETOP10\t$project";
            my $k =$project;
            if($sv_or_cnv_type =~/del_svscore/){ #sv type 为del_svscore
                push @{$hash8{$k}},$v_sv_cnv;
            }
            elsif($sv_or_cnv_type =~/dup_svscore/){ #sv type 为dup_svscore
                push @{$hash9{$k}},$v_sv_cnv;
            }
            else{
                if ($sv_or_cnv_type =~/inv_svscore/){ #sv type 为inv_svscore
                    push @{$hash10{$k}},$v_sv_cnv;
                }
                elsif($sv_or_cnv_type =~/tra_svscore/){ #sv type 为tra_svscore
                    push @{$hash11{$k}},$v_sv_cnv;
                }
                else{
                    if($sv_or_cnv_type =~/cnv_svscore/){ ##sv type 为cnv_svscore
                        push @{$hash12{$k}},$v_sv_cnv;
                    }
                }
            }
        }
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
    my @projects = @{$hash32{$k}};
    my %hash33;
    @projects = grep { ++$hash33{$_} < 2 } @projects;
    #-----------------------------------------------------------------------------#计算average_del_svscore(除以gene hotspot pair number)
    my @dels =();
    my @dups =();
    my @invs =();
    my @tras =();
    my @cnvs =();
    foreach my $project(@projects){
        if(exists $hash8{$project}){
            my @del_infos = @{$hash8{$project}};
            my %hash21;
            @del_infos = grep { ++$hash21{$_} < 2 } @del_infos;
            push @dels,@del_infos; ##把@del_infos中的元素加到@dels
        }
        #----------------------------------------------------------------------------#计算average_dup_svscore(除以hotspot number)
        if(exists $hash9{$project}){
            my @dup_infos = @{$hash9{$project}};
            my %hash22;
            @dup_infos = grep { ++$hash22{$_} < 2 } @dup_infos;
            push @dups,@dup_infos
        }
        #-------------------------------------------------------------------------------#计算average_inv_svscore(除以hotspot number)
        if(exists $hash10{$project}){
            my @inv_infos = @{$hash10{$project}};
            my %hash23;
            @inv_infos = grep { ++$hash23{$_} < 2 } @inv_infos;
            push @invs,@inv_infos;
        }
        #-----------------------------------------------------------------------------##计算average_tra_svscore(除以hotspot number)
        if(exists $hash11{$project}){
            my @tra_infos = @{$hash11{$project}};
            my %hash24;
            @tra_infos = grep { ++$hash24{$_} < 2 } @tra_infos;
            my $tra_gene_number = @tra_infos;
            push @tras,@tra_infos;
        }
        #-------------------------------------------------------------------------------##计算average_cnv_svscore(除以hotspot number)
        if(exists $hash12{$project}){
            my @cnv_infos = @{$hash12{$project}};
            my %hash25;
            @cnv_infos = grep { ++$hash25{$_} < 2 } @cnv_infos;
            push @cnvs,@cnv_infos;
        }
    }
    #---------------------------------------------------------------------#计算average_del_svscore
    my %hash34;
    @dels = grep { ++$hash34{$_} < 2 } @dels;
    my @del_svscore= ();
    my $del_gene_number = @dels;
    if ($del_gene_number>0){
        foreach my $del(@dels){
            my @f = split/\t/,$del;
            my $svscore = $f[1];
            push @del_svscore,$svscore;
        }
        my $sum_del_svscore = sum @del_svscore;
        my $average_del_svscore = $sum_del_svscore/$del_gene_number;
        push @outputs,$average_del_svscore;
    }
    else{
        my $average_del_svscore =0;
        push @outputs,$average_del_svscore;
    }
    #-------------------------------------------------------------------------#计算average_dup_svscore
    my %hash35;
    @dups = grep { ++$hash35{$_} < 2 } @dups;
    my @dup_svscore= ();
    my $dup_gene_number = @dups;
    if ($dup_gene_number >0){
        foreach my $dup (@dups){
            my @f = split/\t/,$dup; 
            my $svscore = $f[1];
            push @dup_svscore,$svscore;
        }
        my $sum_dup_svscore = sum @dup_svscore;
        my $average_dup_svscore = $sum_dup_svscore/$dup_gene_number;
        push @outputs,$average_dup_svscore; 
    }
    else{
        my $average_dup_svscore =0;
        push @outputs,$average_dup_svscore;
    }   
    #-------------------------------------------------------------------------------#计算average_inv_svscore
    my %hash36;
    @invs = grep { ++$hash36{$_} < 2 } @invs;
    my @inv_svscore= ();
    my $inv_gene_number = @invs;
    if ($inv_gene_number >0){
        foreach my $inv (@invs){
            my @f = split/\t/,$inv; 
            my $svscore = $f[1];
            push @inv_svscore,$svscore;
        }
        my $sum_inv_svscore = sum @inv_svscore;
        my $average_inv_svscore = $sum_inv_svscore/$inv_gene_number;
        push @outputs,$average_inv_svscore; 
    }
    else{
        my $average_inv_svscore =0;
        push @outputs,$average_inv_svscore;
    }   
    #-------------------------------------------------------------------------------#计算average_tra_svscore
    my %hash37;
    @tras = grep { ++$hash37{$_} < 2 } @tras;
    my @tra_svscore= ();
    my $tra_gene_number = @tras;
    if ($tra_gene_number >0){
        foreach my $tra (@tras){
            my @f = split/\t/,$tra; 
            my $svscore = $f[1];
            push @tra_svscore,$svscore;
        }
        my $sum_tra_svscore = sum @tra_svscore;
        my $average_tra_svscore = $sum_tra_svscore/$tra_gene_number;
        push @outputs,$average_tra_svscore; 
    }
    else{
        my $average_tra_svscore =0;
        push @outputs,$average_tra_svscore;
    }   
    #-------------------------------------------------------------------------------##计算average_cnv_svscore
    my %hash38;
    @cnvs = grep { ++$hash38{$_} < 2 } @cnvs;
    my @cnv_svscore= ();
    my $cnv_gene_number = @cnvs;
    if ($cnv_gene_number >0){
        foreach my $cnv (@cnvs){
            my @f = split/\t/,$cnv; 
            my $svscore = $f[1];
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
    my $outputs_features = join("\t",@outputs);
    my $final_output = "$k\t$outputs_features";
    print $O1 "$final_output\n";        
}