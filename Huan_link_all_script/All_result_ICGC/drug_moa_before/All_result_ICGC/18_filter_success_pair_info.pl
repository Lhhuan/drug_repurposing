 #把17_drug_repo_cancer_pairs_may_success.txt中的drug_repo pair从16_gene_based_ICGC_somatic_repo_may_success.txt的全部信息（整行）筛选出来。得文件18_gene_based_ICGC_somatic_repo_may_success.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  



my $f1 ="./17_drug_repo_cancer_pairs_may_success.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./16_gene_based_ICGC_somatic_repo_may_success.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./18_gene_based_ICGC_somatic_repo_may_success.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

#my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_ID\tproject_full_name\toncotree_term\toncotree_ID\tgene_role_in_cancer";
my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$title = "$title\tDrug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID";

print $O1 "$title\n";



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
        my $drug = $f[13];
        my $indication = $f[-1];
        $indication =~ s/"//g;
        my $cancer = $f[11];
        my $k = "$drug\t$cancer";
        push @{$hash2{$k}},$_;
    }
}

foreach my $drug (sort keys %hash1){
    my @infos = @{$hash2{$drug}};
    foreach my $info(@infos){
        unless(exists $hash3{$info}){
            $hash3{$info}=1;
            print $O1 "$info\n";
        }
    }
}


