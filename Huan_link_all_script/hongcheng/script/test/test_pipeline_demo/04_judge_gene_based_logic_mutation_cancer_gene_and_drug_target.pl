#判断./output/03_gene_based_merge_mutation_gene_MOA_cancer_drug.txt中突变，癌症基因和药物靶点的逻辑，
#得总文件./output/04_judge_gene_based_logic_mutation_cancer_gene_and_drug_target.txt
#得逻辑正确文件./output/04_judge_gene_based_mutation_cancer_gene_and_drug_target_logic_true.txt
#得逻辑错误文件./output/04_judge_gene_based_mutation_cancer_gene_and_drug_target_logic_conflict.txt
#得没有逻辑文件./output/04_judge_gene_based_mutation_cancer_gene_and_drug_target_logic_no.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/03_gene_based_merge_mutation_gene_MOA_cancer_drug.txt";
my $fo1 ="./output/04_judge_gene_based_logic_mutation_cancer_gene_and_drug_target.txt"; 
my $fo2 ="./output/04_judge_gene_based_mutation_cancer_gene_and_drug_target_logic_true.txt"; 
my $fo3 ="./output/04_judge_gene_based_mutation_cancer_gene_and_drug_target_logic_conflict.txt"; 
my $fo4 ="./output/04_judge_gene_based_logic_mutation_cancer_gene_and_drug_target_no_logic.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
my $output= "Variant_id\tENSG\tConsequence\tProtein\tB_sift_score\tmutation_to_gene_moa\tEntrez\tTumour_Types\tcancer_gene_normal_MOA\tMOA_rule";
$output = "$output\tDrug_chembl_id_Drug_claim_primary_name\tGene_symbol\tEntrez_id\tDrug_claim_primary_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tClinical_phase\tDrug_indication_Indication_class\tIndication_ID";
$output = "$output\tDrug_type\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\tdrug_target_score\tPACTIVITY_median";
print $O1 "$output\tfinal_logic\n";
print $O2 "$output\n";
print $O3 "$output\n";
print $O4 "$output\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);


while(<$I1>)
{
    chomp;
    unless(/^Variant_id/){
        my @f= split /\t/;
        my $mutation_to_gene_moa = $f[5];
        my $cancer_gene_normal_MOA= $f[8];
        my $MOA_rule = $f[9];
        my $Drug_type = $f[20];
        if ($MOA_rule =~/Strict/){ #B-SFIT direction may not be necessarily same with cancer type effect,but B-SFIT direction is final MOA
            if ($mutation_to_gene_moa =~/LOF/){ #b-sift is LOF
                if ($cancer_gene_normal_MOA =~/TSG|TSG,Oncogene|NA/){ #cancer moa为TSG;TSG,Oncogene;NA 均为mutation moa 和cancer gene logic true 
                    if ($Drug_type =~/A|Both/){ #drug type 为A，Both final logic 为true
                        print $O1 "$_\tlogic_true\n";
                        print $O2 "$_\n";
                    }
                    elsif($Drug_type =~/I/){#drug type 为I,final logic 为logic conflict
                        print $O1 "$_\tlogic_conflict\n";
                        print $O3 "$_\n";
                    }
                    else{ #drug type 为Unknown，Both, final logic 为 no logic
                        print $O1 "$_\tno_logic\n";
                        print $O4 "$_\n";
                    }
                }
                else{ #cancer gene moa 为Oncogene， mutation moa 和cancer gene logic 为false
                    print $O1 "$_\tlogic_conflict\n";
                    print $O3 "$_\n";
                }
            }
            elsif($mutation_to_gene_moa =~/GOF/){ #b-sift is LOF
                if($cancer_gene_normal_MOA =~/Oncogene|TSG,Oncogene|NA/){ #cancer moa 为Oncogene; TSG,Oncogene; NA 均为mutation moa 和cancer gene logic true 
                    if ($Drug_type =~/I/){# #drug type 为I， final logic 为true
                        print $O1 "$_\tlogic_true\n";
                        print $O2 "$_\n";
                    }
                    elsif($Drug_type =~/A/){##drug type 为A,final logic 为logic conflict
                        print $O1 "$_\tlogic_conflict\n";
                        print $O3 "$_\n";
                    }
                    else{  #drug type 为Unknown，Both, final logic 为 no logic
                        print $O1 "$_\tno_logic\n";
                        print $O4 "$_\n";
                    }

                }
                else{  ##cancer gene moa 为TSG， logic 为false
                    print $O1 "$_\tlogic_conflict\n";
                    print $O3 "$_\n";
                }
            }
            else{ #cancer gene moa 为 NA #b-sift is NA
                print $O1 "$_\tno_logic\n";
                print $O4 "$_\n";
            }
        }
        else{  #MOA_rule是Loose B-SFIT direction is final mutation moa 和cancer gene logic
            if ($mutation_to_gene_moa =~/LOF/){
                if ($Drug_type =~/A/){ #drug type 为A，Both final logic 为true
                    print $O1 "$_\tlogic_true\n";
                    print $O2 "$_\n";
                }
                elsif($Drug_type =~/I/){#drug type 为I,final logic 为logic conflict
                    print $O1 "$_\tlogic_conflict\n";
                    print $O3 "$_\n";
                }
                else{ #drug type 为Unknown，Both, final logic 为 no logic
                    print $O1 "$_\tno_logic\n";
                    print $O4 "$_\n";
                }                
            }
            elsif($mutation_to_gene_moa =~/GOF/){
                if ($Drug_type =~/I/){# #drug type 为I，Both final logic 为true
                    print $O1 "$_\tlogic_true\n";
                    print $O2 "$_\n";
                }
                elsif($Drug_type =~/A/){##drug type 为A,final logic 为logic conflict
                    print $O1 "$_\tlogic_conflict\n";
                    print $O3 "$_\n";
                }
                else{ #drug type 为Unknown，Both, final logic 为 no logic
                    print $O1 "$_\tno_logic\n";
                    print $O4 "$_\n";
                }
            }
            else{ #b-sift is NA
                print $O1 "$_\tno_logic\n";
                print $O4 "$_\n";
            }

        }
    }
}

