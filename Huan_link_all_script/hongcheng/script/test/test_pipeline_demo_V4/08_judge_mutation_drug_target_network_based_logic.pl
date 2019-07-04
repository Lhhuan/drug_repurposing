##把网络最短路径的文件/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/10_start_end_logical.txt及./output/07_merge_drug_target_network_id_success_pair_info.txt.gz merge在一起，
#并判断最短路径的逻辑和drug target 和cancer gene的逻辑，得逻辑一致的文件./output/08_judge_mutation_drug_target_network_based_logic_true.txt.gz,得逻辑不一致的文件./output/08_judge_mutation_drug_target_network_based_logic_conflict.txt.gz,
#得没有逻辑的文件./output/08_judge_mutation_drug_target_network_based_no_logic.txt.gz,####得总文件./output/08_judge_mutation_drug_target_network_based_logic.txt.gz
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/10_start_end_logical.txt";
my $f2 ="./output/07_merge_drug_target_network_id_success_pair_info.txt.gz";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n"); #读压缩文件
my $fo1 ="./output/08_judge_mutation_drug_target_network_based_logic_true.txt.gz"; 
open my $O1, "| gzip >$fo1" or die $!;
my $fo2 ="./output/08_judge_mutation_drug_target_network_based_logic_conflict.txt.gz"; 
open my $O2, "| gzip >$fo2" or die $!;
my $fo3 ="./output/08_judge_mutation_drug_target_network_based_no_logic.txt.gz"; 
open my $O3, "| gzip >$fo3" or die $!;
my $fo4 ="./output/08_judge_mutation_drug_target_network_based_logic.txt.gz"; 
open my $O4, "| gzip >$fo4" or die $!;
# my $header = "the_shortest_path\tpath_logic_direction\tshortest_path_length"
# $header = "$header\tnetwork_drug_name\tstart_id\tstart_entrez\trandom_overlap_fact_end\tnormal_score_P"; #network
# $header = "$header\tcancer_entrez"; #
# $header = "$header\tVariant_id\tENSG\tConsequence\tProtein\tB_sift_score\tmutation_to_gene_moa\tCancer_Entrez\tTumour_Types\tcancer_gene_normal_MOA\tMOA_rule"; #mutation
# $header = "$header\tDrug_chembl_id_Drug_claim_primary_name\tGene_symbol\tdrug_target_Entrez_id\tDrug_claim_primary_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tClinical_phase\tDrug_indication_Indication_class\tIndication_ID";
# $header = "$header\tDrug_type\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\tdrug_target_score\tPACTIVITY_median";
# $header = "$header\tdrug_target_network_id";
my $header = "the_shortest_path\tpath_logic_direction\tshortest_path_length";
$header= "$header\tnetwork_drug_name\tstart_id\tstart_entrez\trandom_overlap_fact_end\tnormal_score_P"; #network
$header = "$header\tVariant_id\tENSG\tConsequence\tProtein\tB_sift_score\tmutation_to_gene_moa\tEntrez\tTumour_Types\tcancer_gene_normal_MOA\tMOA_rule"; #mutation
$header= "$header\tDrug_chembl_id_Drug_claim_primary_name\tGene_symbol\tEntrez_id";
$header= "$header\tDrug_type\tdrug_target_score\tPACTIVITY_median";
$header = "$header\tdrug_target_network_id";
$header = "$header\tfinal_logic";
print $O1 "$header\n";
print $O2 "$header\n";
print $O3 "$header\n";
print $O4 "$header\n";



my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    unless(/^start/){
        my @f= split /\t/;
        my $start_id = $f[0];
        my $end_id = $f[1];
        my $logic_direction = $f[2];
        my $path_length = $f[3];
        my $k4 = "${start_id}_${end_id}";
        my $v4 = "$logic_direction\t$path_length";
        $hash4{$k4}=$v4;
    }
}


while(<$I2>)
{
    chomp;
    my @f1= split /\t/;
    unless(/^drug_name_network/){
        my $drug = $f1[0];
        my $start_id1 = $f1[1];
        my $random_overlap_fact_end_id = $f1[3];
        my $start_id = $f1[-1];
        my $k = "${start_id}_${random_overlap_fact_end_id}"; 
        if(exists $hash4{$k}){ #最短路径是否符合要求
            my $logic_path =$hash4{$k}; #寻找最短路径逻辑和长度
            my $output = "$k\t$logic_path\t$_";
            my @f= split /\t/,$output;
            my $path_logic = $f[1];
            my $mutation_to_gene_moa =$f[13];
            my $cancer_gene_normal_MOA =$f[16];
            my $MOA_rule = $f[17];
            my $drug_type =$f[21];
            # print "$path_logic\t$mutation_to_gene_moa\t$cancer_gene_normal_MOA\t$MOA_rule\t$drug_type\n";
            if ($MOA_rule =~/Strict/){ #B-SFIT direction may not be necessarily same with cancer type effect,but B-SFIT direction is final MOA
                if ($mutation_to_gene_moa =~/LOF/){ #b-sift is LOF
                    if ($cancer_gene_normal_MOA =~/TSG|TSG,Oncogene|NA/){ #cancer moa为TSG;TSG,Oncogene;NA 均为mutation moa 和cancer gene logic true 
                        if($drug_type=~/I/){
                            if($path_logic=~/in/){  #三者乘积为-1，logic true
                                print $O1 "$output\ttrue\n";
                                print $O4 "$output\ttrue\n";
                            }
                            elsif($path_logic=~/a|-/){ #三者乘机为1，logic conflict
                                print $O2 "$output\tconflict\n";
                                print $O4 "$output\tconflict\n";
                            }
                        }
                        elsif($drug_type=~/A/){
                            if($path_logic =~/in/){ #三者乘机为1，logic conflict
                                print $O2 "$output\tconflict\n"; 
                                print $O4 "$output\tconflict\n";
                            }
                            elsif($path_logic =~/a|-/){ #三者乘积为-1，logic true
                                print $O1 "$output\ttrue\n";
                                print $O4 "$output\ttrue\n";
                            }
                        }
                        else{ #drug target 为na或者A,I
                            print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                            print $O4 "$output\tno\n";
                        }
                    }
                    else{ #cancer gene moa 为Oncogene， mutation moa 和cancer gene logic 为false
                        print $O2 "$output\tconflict\n";
                        print $O4 "$output\tconflict\n";
                    }
                }
                elsif($mutation_to_gene_moa =~/GOF/){ #b-sift is LOF
                    if($cancer_gene_normal_MOA =~/Oncogene|TSG,Oncogene|NA/){ #cancer moa 为Oncogene; TSG,Oncogene; NA 均为mutation moa 和cancer gene logic true 
                        if($drug_type=~/I/){
                            if($path_logic =~/in/){ #三者乘机为1，logic conflict
                                print $O2 "$output\tconflict\n";
                                print $O4 "$output\tconflict\n";
                            }
                            elsif($path_logic =~/a|-/){ #三者乘积为-1，logic true
                                    print $O1 "$output\ttrue\n";
                                    print $O4 "$output\ttrue\n";
                            }
                        }
                        elsif($drug_type =~/A/){
                            if($path_logic =~/in/){ #三者乘积为-1，logic true
                                print $O1 "$output\ttrue\n"; 
                                print $O4 "$output\ttrue\n"; 
                            }
                            elsif($path_logic =~/a|-/){ #三者乘机为1，logic conflict
                                print $O2 "$output\tconflict\n";
                                print $O4 "$output\tconflict\n";
                            }
                        }
                        else{ #drug target 为na
                            print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                            print $O4 "$output\tno\n";
                        }
                    }
                    else{#cancer gene moa 为TSG， mutation moa 和cancer gene logic 为false
                        print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                        print $O4 "$output\tno\n";
                    }
                }
                else{ #cancer gene moa 为 NA #b-sift is NA
                    print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                    print $O4 "$output\tno\n";
                }
            }
            else{  #MOA_rule是Loose B-SFIT direction is final mutation moa 和cancer gene logic
                if($mutation_to_gene_moa=~/LOF/){
                    if($drug_type=~/I/){
                        if($path_logic=~/in/){  #三者乘积为-1，logic true
                            print $O1 "$output\ttrue\n";
                            print $O4 "$output\ttrue\n";
                        }
                        elsif($path_logic=~/a|-/){ #三者乘机为1，logic conflict
                            print $O2 "$output\tconflict\n";
                            print $O4 "$output\tconflict\n";
                        }
                    }
                    elsif($drug_type=~/A/){
                        if($path_logic =~/in/){ #三者乘机为1，logic conflict
                            print $O2 "$output\tconflict\n"; 
                            print $O4 "$output\tconflict\n";
                        }
                        elsif($path_logic =~/a|-/){ #三者乘积为-1，logic true
                            print $O1 "$output\ttrue\n";
                            print $O4 "$output\ttrue\n";
                        }
                    }
                    else{ #drug target 为na或者A,I
                        print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                        print $O4 "$output\tno\n";
                    }
                }
                else{ #此时cancer gene moa是GOF或者NA
                    if($mutation_to_gene_moa=~/GOF/){ 
                        if($drug_type=~/I/){
                            if($path_logic =~/in/){ #三者乘机为1，logic conflict
                                print $O2 "$output\tconflict\n";
                                print $O4 "$output\tconflict\n";
                            }
                            elsif($path_logic =~/a|-/){ #三者乘积为-1，logic true
                                    print $O1 "$output\ttrue\n";
                                    print $O4 "$output\ttrue\n";
                            }
                        }
                        elsif($drug_type =~/A/){
                            if($path_logic =~/in/){ #三者乘积为-1，logic true
                                print $O1 "$output\ttrue\n"; 
                                print $O4 "$output\ttrue\n"; 
                            }
                            elsif($path_logic =~/a|-/){ #三者乘机为1，logic conflict
                                print $O2 "$output\tconflict\n";
                                print $O4 "$output\tconflict\n";
                            }
                        }
                        else{ #drug target 为na
                            print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                            print $O4 "$output\tno\n";
                        }
                    }
                    else{#此时cancer gene moa是NA
                        print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                        print $O4 "$output\tno\n";
                    }
                }
            }
        }
    }
}


