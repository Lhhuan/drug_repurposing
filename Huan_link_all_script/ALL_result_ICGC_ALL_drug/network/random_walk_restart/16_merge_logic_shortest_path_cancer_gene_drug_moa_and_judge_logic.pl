##把网络最短路径的文件./output/10_start_end_logical.txt及./output/15.1_merge_drug_target_network_id_success_pair_info.txt merge在一起，得文件./output/16_merge_logic_shortest_path_cancer_gene_drug_moa.txt（因为测试过中间文件很大，所以就不输出了，直接对其判断逻辑）
#并判断最短路径的逻辑和drug target 和cancer gene的逻辑，得逻辑一致的文件./output/16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt,得逻辑不一致的文件./output/16_judge_the_shortest_drug_target_cancer_gene_logic_conflict.txt,
#得没有逻辑的文件./output/16_judge_the_shortest_drug_target_cancer_gene_no_logic.txt,####得总文件./output/16_judge_the_shortest_drug_target_cancer_gene_logic.txt.gz
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  


my $f1 ="./output/15.1_merge_drug_target_network_id_success_pair_info.txt.gz";
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); #读压缩文件
my $f2 ="./output/10_start_end_logical.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt.gz"; 
open my $O1, "| gzip >$fo1" or die $!;
my $fo2 ="./output/16_judge_the_shortest_drug_target_cancer_gene_logic_conflict.txt.gz"; 
open my $O2, "| gzip >$fo2" or die $!;
my $fo3 ="./output/16_judge_the_shortest_drug_target_cancer_gene_no_logic.txt.gz"; 
open my $O3, "| gzip >$fo3" or die $!;
my $fo4 ="./output/16_judge_the_shortest_drug_target_cancer_gene_logic.txt.gz"; 
open my $O4, "| gzip >$fo4" or die $!;

my $header ="the_shortest_path\tpath_logic\tpath_length\tdrug_name_network\tstart_id\tstart_entrez\trandom_overlap_fact_end_id\tnormal_score_P\tend_entrze\tCADD_MEANPHRED\tMutation_ID\tCancer_ENSG_ID\tMap_to_gene_level\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail";
$header = "$header\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$header ="$header\tDrug_chembl_id_Drug_claim_primary_name\tGene_symbol\tEntrez_id\tENSG_ID\tDrug_type\tdrug_target_score\tdrug_target_network_id\tthe_final_logic";
print $O1 "$header\n";
print $O2 "$header\n";
print $O3 "$header\n";
print $O4 "$header\n";



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
            my $drug_type =$f[-3];
            if($Role_in_cancer=~/LOF,GOF/){ ##gene role是LOF，GOF时表明gene 既有可能是lof,也有可能是GOF，所以不管drug是A和I或者both都有可能是对的，所以这里算逻辑上对
                 print $O1 "$output\ttrue\n";
                 print $O4 "$output\ttrue\n";
            }
            elsif($Role_in_cancer=~/LOF/){
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
            else{ #此时$Role_in_cancer是GOF或者NA
                if($Role_in_cancer=~/GOF/){ 
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
                else{#此时$Role_in_cancer是NA
                    print $O3 "$output\tno\n"; #drug target 为unknown无法判断其logic 类型
                    print $O4 "$output\tno\n";
                }
            }
        }
    }
}


