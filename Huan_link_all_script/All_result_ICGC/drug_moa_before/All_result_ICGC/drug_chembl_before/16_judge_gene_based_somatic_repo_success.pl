#判断15_cancer_gene_drug_indication_oncotree.txt 里的数据drug indication和cancer 是同一疾病。得是同一疾病的文件16_gene_based_ICGC_somatic_repo_fail.txt
#得不是同一种疾病的文件16_gene_based_ICGC_somatic_repo_may_success.txt,是否真的repo成功，还需要再check
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./15_cancer_gene_drug_indication_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./16_gene_based_ICGC_somatic_repo_fail.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./16_gene_based_ICGC_somatic_repo_may_success.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

#my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_ID\tproject_full_name\toncotree_term\toncotree_ID\tgene_role_in_cancer";
my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\toncotree_term\toncotree_ID\tgene_role_in_cancer";
$title = "$title\tDrug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication-OncoTree_term\tindication-OncoTree_IDs";
print $O1 "$title\n";
print $O2 "$title\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Mutation_ID/){
         my $ICGC_cancer_oncotree =$f[8];
         my $indication_oncotree = $f[-1];
         if ($indication_oncotree eq $ICGC_cancer_oncotree){
             print $O1 "$_\n";
         }
         else{
             print $O2 "$_\n";
         }
     }
}

