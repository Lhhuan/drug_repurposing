##把./output/13_ICGC_cancer_gene_drug_information.txt和./output/all_id_indication_do_hpo_oncotree.txt,merge在一起，得到文件./output/15_cancer_gene_drug_indication_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my $f1 ="./output/all_id_indication_do_hpo_oncotree.txt";
my $f2 ="./output/13_ICGC_cancer_gene_drug_information.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/15_cancer_gene_drug_indication_oncotree.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


# my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_ID\tproject_full_name\toncotree_term\toncotree_ID\tgene_role_in_cancer";
my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$title = "$title\tDrug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name";
$title ="$title\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID";
print $O1 "$title\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Indication_ID/){
         my $indicatuion_id =$f[0];
         my $v= join("\t",@f[2..9]);
         $hash1{$indicatuion_id} = $v;
     }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Mutation_ID/){
        my $indicatuion_id =$f[-2];
        if (exists $hash1{$indicatuion_id}){
            my $indication = $hash1{$indicatuion_id};
            print $O1 "$_\t$indication\n";
        }
        else{
            print STDERR "$indicatuion_id\n";
        }
    }
}


