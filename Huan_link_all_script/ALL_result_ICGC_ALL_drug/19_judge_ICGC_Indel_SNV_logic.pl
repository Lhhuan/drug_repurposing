#判断./output/15_cancer_gene_drug_indication_oncotree.txt是否有逻辑，为其在原文件后加logic label得./output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt得逻辑对的上的文件./output/19_ICGC_Indel_SNV_repo-may_success_logic_true.txt 
#得没有逻辑的文件./output/19_ICGC_Indel_SNV_repo-may_success_no_logic.txt,得逻辑相反的文件./output/19_ICGC_Indel_SNV_repo-may_success_logic_conflict.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/15_cancer_gene_drug_indication_oncotree.txt";
my $fo1 ="./output/19_ICGC_Indel_SNV_repo-may_success_logic_true.txt"; #逻辑一致
my $fo2 = "./output/19_ICGC_Indel_SNV_repo-may_success_logic_conflict.txt";#逻辑不一致 
my $fo3 = "./output/19_ICGC_Indel_SNV_repo-may_success_no_logic.txt";#没有逻辑
my $fo4 = "./output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt";  #相当于给18_gene_based_ICGC_somatic_repo_may_success.txt加了逻辑的标签，no，true,conflict
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";

#my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_ID\tproject_full_name\toncotree_term\toncotree_ID\tgene_role_in_cancer";
my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$title = "$title\tDrug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name";
$title ="$title\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID";

print $O1 "$title\n";
print $O2 "$title\n";
print $O3 "$title\n";
print $O4 "$title\tlogic\n";



my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Mutation_ID/){
         my $Role_in_cancer = $f[12];
         my $drug_type = $f[30];
         if ($Role_in_cancer=~/LOF,GOF/){
            print $O1 "$_\n"; #gene role是LOF，GOF时表明gene 既有可能是lof,也有可能是GOF，所以不管drug是A和I或者both都有可能是对的，所以这里算逻辑上对
            print $O4 "$_\ttrue\n";
         }
         else{
            if($Role_in_cancer=~/LOF/){
                if($drug_type=~/A/){
                    print $O1 "$_\n";
                    print $O4 "$_\ttrue\n";
                }
                elsif($drug_type=~/I/){
                    print $O2 "$_\n";
                    print $O4 "$_\tconflict\n";
                }
                else{  #这里的unknown和both都按没有逻辑算。
                    print $O3 "$_\n";
                    print $O4 "$_\tno\n";
                }
            }
            elsif($Role_in_cancer=~/GOF/){
                if($drug_type=~/I/){
                    print $O1 "$_\n";
                    print $O4 "$_\ttrue\n";
                }
                elsif($drug_type=~/A/){
                    print $O2 "$_\n";
                    print $O4 "$_\tconflict\n";
                }
                else{
                    print $O3 "$_\n";
                    print $O4 "$_\tno\n";
                }
            }
            else{
                print $O3 "$_\n";
                print $O4 "$_\tno\n";
            }
         }
     }
}


