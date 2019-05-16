# 对Gene_based_drug_cancer_pairs_information： "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt"进行过滤
#得./data/Gene_based_drug_cancer_pairs_information.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt";
my $fo1 ="./data/Gene_based_drug_cancer_pairs_information.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Mutation_ID\tMap_to_gene_level\tentrezgene\tENSG_ID\tproject\tcancer_specific_affected_donors\tgene_role_in_cancer\tDrug_chembl_id_Drug_claim_primary_name\tDrug_type\tlogic\n";



my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Mutation_ID/){
        my $Mutation_ID = $f[0];
        my $Map_to_gene_level = $f[1];
        my $entrezgene = $f[2];
        my $project = $f[3];
        my $cancer_specific_affected_donors = $f[4];
        my $cancer_ID =$f[5];
        my $project_full_name = $f[6];
        my $project_full_name_from_project = $f[7];
        my $oncotree_term_detail = $f[8];
        my $oncotree_ID_detail = $f[9];
        my $oncotree_term_main_tissue = $f[10];
        my $oncotree_ID_main_tissue = $f[11];
        my $gene_role_in_cancer = $f[12];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[13];
        my $Entrez_id = $f[15];
        my $ENSG_ID = $f[27];
        my $Drug_type = $f[30];
        my $logic = $f[-1];
        my $output = "$Mutation_ID\t$Map_to_gene_level\t$entrezgene\t$ENSG_ID\t$project\t$cancer_specific_affected_donors\t$gene_role_in_cancer\t$Drug_chembl_id_Drug_claim_primary_name\t$Drug_type\t$logic";
        unless (exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}


