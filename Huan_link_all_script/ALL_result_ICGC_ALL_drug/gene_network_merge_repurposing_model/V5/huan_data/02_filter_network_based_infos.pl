#因为"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt.gz"文件太大，
#提取"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic_true.txt.gz"
#中不部分列，用来计算feature，得./output/02_filter_network_based_infos.txt.gz,并对./output/02_filter_network_based_infos.txt.gz进行去重得
#./output/02_unique_filter_network_based_infos.txt.gz
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic.txt.gz";
my $fo1 ="./output/02_filter_network_based_infos.txt.gz"; 
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); #读压缩文件
open my $O1, "| gzip >$fo1" or die $!;

my $header = "Drug_chembl_id_Drug_claim_primary_name\tDrug_claim_primary_name\tdrug_entrze\tdrug_ENSG\tdrug_target_score\tend_entrze\tthe_shortest_path\tpath_length\tnormal_score_P\tMutation_ID\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED";
$header = "$header\tcancer_ENSG\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tthe_final_logic\tMap_to_gene_level\tproject\tmap_to_gene_level_score";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^the_shortest_path/){
       my $the_shortest_path = $f[0];
       my $path_length = $f[2];
       my $normal_score_P = $f[7];
       my $end_entrze = $f[8];
       my $CADD_MEANPHRED = $f[9];
       my $Mutation_ID = $f[10];
       my $cancer_ENSG = $f[11];
       my $map_to_gene_level = $f[12];
       my $project = $f[13];
       my $cancer_specific_affected_donors = $f[14];
       my $original_cancer_id = $f[15];
       my $oncotree_term_detail = $f[18];
       my $oncotree_ID_detail = $f[19];
       my $oncotree_term_main_tissue = $f[20];
       my $oncotree_ID_main_tissue =$f[21];
       my $Drug_chembl_id_Drug_claim_primary_name = $f[23];
       my $Drug_claim_primary_name= "unwrite" ;#为了不改动后面的脚本，所以在这里加一列空值.
       my $drug_entrze = $f[25];
       my $drug_ENSG = $f[26];
       my $drug_target_score = $f[-3];
       my $the_final_logic = $f[-1];
       my $output1 = "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_claim_primary_name\t$drug_entrze\t$drug_ENSG\t$drug_target_score\t$end_entrze\t$the_shortest_path\t$path_length\t$normal_score_P\t$Mutation_ID\t$cancer_specific_affected_donors\t$original_cancer_id\t$CADD_MEANPHRED";
       $output1 = "$output1\t$cancer_ENSG\t$oncotree_term_detail\t$oncotree_ID_detail\t$oncotree_term_main_tissue\t$oncotree_ID_main_tissue\t$the_final_logic\t$map_to_gene_level\t$project";
       if ($the_final_logic =~/true|no/){
            if($map_to_gene_level=~/Level1_1_protein_coding/){ #Level1_1_protein_coding 给score 为5
                print $O1 "$output1\t5\n";
            }
            elsif($map_to_gene_level=~/Level1_2_protein_coding/){   #Level1_2_protein_coding 给score 为4 
                print $O1 "$output1\t4\n";
            }
            else{
                if($map_to_gene_level=~/level2_enhancer_target/){ #level2_enhancer_target 给score 为3   
                    print $O1 "$output1\t3\n";
                }
                elsif($map_to_gene_level=~/level3.1/){ #level3.1 给score 为2 
                    print $O1 "$output1\t2\n";
                }
                else{
                    if ($map_to_gene_level=~/level3.2/){ #level3.2 给score 为1
                        print $O1 "$output1\t1\n";
                    }
                }
            }
        }
        
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
system "zless ./output/02_filter_network_based_infos.txt.gz | sort -u| gzip > ./output/02_unique_filter_network_based_infos.txt.gz" ; #暂时注释