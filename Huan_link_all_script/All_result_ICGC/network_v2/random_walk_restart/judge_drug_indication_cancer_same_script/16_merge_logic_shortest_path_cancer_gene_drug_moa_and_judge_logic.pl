##把网络最短路径的文件10_start_end_logical.txt及15.1_merge_drug_target_network_id_success_pair_info.txt merge在一起，得文件16_merge_logic_shortest_path_cancer_gene_drug_moa.txt（因为测试过中间文件很大，所以就不输出了，直接对其判断逻辑）
#并判断最短路径的逻辑和drug target 和cancer gene的逻辑，得逻辑一致的文件16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt,得逻辑不一致的文件16_judge_the_shortest_drug_target_cancer_gene_logic_conflict.txt,
#得没有逻辑的文件16_judge_the_shortest_drug_target_cancer_gene_no_logic.txt,####得总文件16_judge_the_shortest_drug_target_cancer_gene_logic.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  


my $f1 ="./15.1_merge_drug_target_network_id_success_pair_info.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./10_start_end_logical.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./16_judge_the_shortest_drug_target_cancer_gene_logic_conflict.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 ="./16_judge_the_shortest_drug_target_cancer_gene_no_logic.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
# my $fo4 ="./16_judge_the_shortest_drug_target_cancer_gene_logic.txt"; 
# open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";

my $header ="the_shortest_path\tpath_logic\tpath_length\tdrug_name_network\tstart_id\tstart_entrez\trandom_overlap_fact_end_id\tnormal_score_P\tend_entrze\tCADD_MEANPHRED\tMutation_ID\tENSG\tMap_to_gene_level\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail";
$header = "$header\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$header ="$header\tDrug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication";
$header = "$header\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail";
$header = "$header\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\tdrug_target_score\tdrug_target_network_id\tthe_final_logic";
print $O1 "$header\n";
print $O2 "$header\n";
print $O3 "$header\n";
# print $O4 "$header\n";



my (%hash1,%hash2,%hash3,%hash4);

while(<$I2>)
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


while(<$I1>)
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
            my $Role_in_cancer = $f[22];
            my $drug_type =$f[-11];
            if($Role_in_cancer=~/LOF,GOF/){ ##gene role是LOF，GOF时表明gene 既有可能是lof,也有可能是GOF，所以不管drug是A和I或者both都有可能是对的，所以这里算逻辑上对
                 print $O1 "$output\ttrue\n";
            }
            elsif($Role_in_cancer=~/LOF/){
                if($drug_type=~/I/){
                    if($path_logic=~/in/){  #三者乘积为-1，logic true
                        print $O1 "$output\ttrue\n";
                    }
                    elsif($path_logic=~/a|-/){ #三者乘机为1，logic conflict
                        print $O2 "$output\tconflict\n";
                    }
                }
                elsif($drug_type=~/A/){
                    if($path_logic =~/in/){ #三者乘机为1，logic conflict
                        print $O2 "$output\tconflict\n"; 
                    }
                    elsif($path_logic =~/a|-/){ #三者乘积为-1，logic true
                        print $O1 "$output\ttrue\n";
                    }
                }
                else{ #drug target 为na
                    print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                }
            }
            else{ #此时$Role_in_cancer是GOF或者NA
                if($Role_in_cancer=~/GOF/){ 
                    if($drug_type=~/I/){
                        if($path_logic =~/in/){ #三者乘机为1，logic conflict
                            print $O2 "$output\tconflict\n";
                        }
                        elsif($path_logic =~/a|-/){ #三者乘积为-1，logic true
                                print $O1 "$output\ttrue\n";
                        }
                    }
                    elsif($drug_type =~/A/){
                        if($path_logic =~/in/){ #三者乘积为-1，logic true
                            print $O1 "$output\ttrue\n"; 
                        }
                        elsif($path_logic =~/a|-/){ #三者乘机为1，logic conflict
                            print $O2 "$output\tconflict\n";
                        }
                    }
                    else{ #drug target 为na
                        print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                    }
                }
                else{#此时$Role_in_cancer是NA
                    print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                }
            }
        }
    }
}


