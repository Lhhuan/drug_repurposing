##把13_ICGC_cancer_gene_drug_information.txt和huan_mapin_do_hpo_oncotree.txt,merge在一起，得到文件15_cancer_gene_drug_indication_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./13_ICGC_cancer_gene_drug_information.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./huan_mapin_do_hpo_oncotree.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./15_cancer_gene_drug_indication_oncotree.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


# my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_ID\tproject_full_name\toncotree_term\toncotree_ID\tgene_role_in_cancer";
my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\toncotree_term\toncotree_ID\tgene_role_in_cancer";
$title = "$title\tDrug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication-OncoTree_term\tindication-OncoTree_IDs";
print $O1 "$title\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Mutation_ID/){
         my $indicatuion_id =$f[-2];
         push @{$hash1{$indicatuion_id}},$_;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Indication_ID/){
         my $indicatuion_id =$f[0];
         my $v= join("\t",@f[2..7]);
         $hash2{$indicatuion_id} = $v;
     }
}

foreach my $id (sort keys %hash1){
    #print $O3 "$ensg_id\n";
    if (exists $hash2{$id}){
        my @drugs = @{$hash1{$id}};
        my $indicatuion= $hash2{$id};
       foreach my $drug(@drugs){
           print $O1 "$drug\t$indicatuion\n";
       }
    }
    else{
        print STDERR "$id\n";
    }
}