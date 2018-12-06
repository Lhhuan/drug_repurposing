##把14_drug_repo_cancer_pairs_may_success.txt中的drug_repo pair从13_network_based_ICGC_somatic_repo_indication_cancer_differ.txt的全部信息（整行）筛选出来。得文件15_network_based_ICGC_somatic_repo_may_success.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  



my $f1 ="./14_drug_repo_cancer_pairs_may_success.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./13_network_based_ICGC_somatic_repo_indication_cancer_differ.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./15_network_based_ICGC_somatic_repo_may_success.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header ="drug_name_network\tstart_id\tstart_entrez\trandom_overlap_fact_end_id\tnormal_score_P\tend_entrze\tCADD_MEANPHRED\tMutation_ID\tENSG\tMap_to_gene_level\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail";
$header = "$header\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$header ="$header\tDrug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication";
$header = "$header\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail";
$header = "$header\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\tdrug_target_score";
print $O1 "$header\n";



my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drug = $f[0];
        my $cancer = $f[1];
        my $k = "$drug\t$cancer";
        $hash1{$k}=1;
    }
}


while(<$I2>)
{
    chomp;
    unless(/^Mutation_ID/){
        my @f= split /\t/;
        my $drug = $f[20];
        my $indications = $f[-2];
        $indications =~ s/"//g;
        my $cancer = $f[18];
        my $k = "$drug\t$cancer";
        if(exists $hash1{$k}){
            print $O1 "$_\n";
        }
    }
}

# foreach my $drug (sort keys %hash1){
#     my @infos = @{$hash2{$drug}};
#     foreach my $info(@infos){
#         print $O1 "$info\n";
#     }
# }


