#用01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt输出用于计算出logistic_regression需要的data的数据，02_data_used_calculate_for_repo_logistic_regression.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt";
my $fo1 = "./02_data_used_calculate_for_repo_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
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

