#把./output/02_unique_filter_network_based_infos.txt.gz 取特定列和
#./output/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt.gz中取特定列merge到一起，得./output/03_merge_gene_based_and_network_based_data.txt.gz
#对./output/03_merge_gene_based_and_network_based_data.txt.gz 进行排序去重得 ./output/03_unique_merge_gene_based_and_network_based_data.txt.gz
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/02_unique_filter_network_based_infos.txt.gz";
my $f2 = "./output/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt.gz";
my $fo1 = "./output/03_merge_gene_based_and_network_based_data.txt.gz";
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); #读压缩文件
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n"); #读压缩文件
open my $O1, "| gzip >$fo1" or die $!;
my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_entrze\tdrug_ENSG\tdrug_target_score\tend_entrze\tthe_shortest_path\tpath_length\tnormal_score_P\tMutation_ID\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED";
$header = "$header\tcancer_ENSG\toncotree_ID_detail\toncotree_ID_main_tissue\tthe_final_logic\tMap_to_gene_level\tproject\tmap_to_gene_level_score\tdata_source";
print $O1 "$header\n";


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug_entrze = $f[2];
        my $drug_ENSG = $f[3];
        my $drug_target_score = $f[4];
        my $end_entrze = $f[5];
        my $the_shortest_path = $f[6];
        my $path_length = $f[7];
        my $normal_score_P = $f[8];
        my $Mutation_ID = $f[9];
        my $cancer_specific_affected_donors = $f[10];
        my $original_cancer_id =$f[11];
        my $CADD_MEANPHRED = $f[12];
        my $cancer_ENSG = $f[13];
        my $oncotree_ID_detail = $f[15];
        my $oncotree_ID_main_tissue =$f[17];
        my $the_final_logic = $f[18];
        my $Map_to_gene_level = $f[19];
        my $project = $f[20];
        my $map_to_gene_level_score = $f[21];
        
        my $output = join("\t",$f[0],@f[2..13],$f[15],$f[17],@f[18..21]);
        print $O1 "$output\tnetwork_based\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^CADD_MEANPHRED/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[15];
        my $drug_entrze = $f[17];
        my $drug_ENSG =$f[29];
        my $drug_target_score = $f[1];
        my $end_entrze = $f[4];
        my $the_shortest_path = "${drug_ENSG}_${drug_ENSG}"; #最短路径用ensg表示，gene based start和end是同一基因
        my $path_length = "0"; #因为start 和 end是同一基因，所以最短路径是0；
        my $normal_score_P = "0"; #因为start 和 end是同一基因，是特别显著，所以在这里把gene based的p设置为0；
        my $mutation_id = $f[2];
        my $cancer_specific_affected_donors = $f[6];
        my $original_cancer_ID = $f[7];
        my $CADD_MEANPHRED = $f[0];
        my $cancer_ENSG = $f[29];
        my $oncotree_ID_detail = $f[11];
        my $cancer_oncotree_main_id = $f[13];
        my $the_final_logic = $f[-1];
        my $map_to_gene_level = $f[3];
        my $project = $f[5];
        my $output = "$Drug_chembl_id_Drug_claim_primary_name\t$drug_entrze\t$drug_ENSG\t$drug_target_score\t$end_entrze\t$the_shortest_path\t$path_length\t$normal_score_P\t$mutation_id";
        my $output1 = "$output\t$cancer_specific_affected_donors\t$original_cancer_ID\t$CADD_MEANPHRED\t$cancer_ENSG\t$oncotree_ID_detail\t$cancer_oncotree_main_id\t$the_final_logic\t$map_to_gene_level\t$project";
        if ($the_final_logic =~ /true|no/){  
            if($map_to_gene_level=~/Level1_1_protein_coding/){ #Level1_1_protein_coding 给score 为5
                print $O1 "$output1\t5\tgene_based\n";
            }
            elsif($map_to_gene_level=~/Level1_2_protein_coding/){   #Level1_2_protein_coding 给score 为4 
                print $O1 "$output1\t4\tgene_based\n";
            }
            else{
                if($map_to_gene_level=~/level2_enhancer_target/){ #level2_enhancer_target 给score 为3   
                    print $O1 "$output1\t3\tgene_based\n";
                }
                elsif($map_to_gene_level=~/level3.1/){ #level3.1 给score 为2 
                    print $O1 "$output1\t2\tgene_based\n";
                }
                else{
                    if ($map_to_gene_level=~/level3.2/){ #level3.2 给score 为1
                        print $O1 "$output1\t1\tgene_based\n";
                    }
                }
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

system "zless ./output/03_merge_gene_based_and_network_based_data.txt.gz | sort -u |gzip > ./output/03_unique_merge_gene_based_and_network_based_data.txt.gz" ; #暂时注释