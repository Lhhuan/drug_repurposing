#把12_merge_ICGC_info_gene_role.txt和refined_huan_target_drug_indication_final_symbol.txt merge 到一起，
#得文件13_ICGC_cancer_gene_drug_information.txt,得没有药物基因的somatic mutation得13_ICGC_no_drug_somatic_path_gene_role.txt,得co_gene是drug_cancer_co_ensg_count.txt
use warnings;
use strict; 
use utf8;

my $f1 ="./12_merge_ICGC_info_gene_role.txt";
my $f2 ="./refined_huan_target_drug_indication_final_symbol.txt";
my $fo1 ="./13_ICGC_cancer_gene_drug_information.txt"; 
my $fo2 = "./13_ICGC_no_drug_somatic_path_gene_role.txt";
my $fo3 = "./13_drug_cancer_co_ensg_count.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$title = "$title\tDrug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name";
$title ="$title\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type";
print $O1 "$title\n";
print $O2 "ENSG\tMutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer\n";

my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Mutation_ID/){
         my $Mutation_ID = $f[0];
         my $ENSG =$f[1];
         my $Map_to_gene_level = $f[2];
         my $entrezgene = $f[3];
         my $project = $f[4];
         my $cancer_specific_affected_donors =$f[5];
         my $cancer_ID = $f[6];
         my $project_full_name = $f[7];
         my $gene_role_in_cancer = $f[13];
         my $k = join ("\t",@f[0,2..13]);
         push @{$hash1{$ENSG}},$k;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $ensg_id = $f[-4];
         push @{$hash2{$ensg_id}},$_;
     }
}


foreach my $ensg_id (sort keys %hash1){
    # print $O3 "$ensg_id\n";
    if (exists $hash2{$ensg_id}){
        print $O3 "$ensg_id\n";
        my @disease_genes = @{$hash1{$ensg_id}};
        my @drug_genes = @{$hash2{$ensg_id}};
        foreach my $disease(@disease_genes){
            foreach my $drug(@drug_genes){
                print $O1 "$disease\t$drug\n";
            }
        }
    } 
    else{
        my @disease_genes = @{$hash1{$ensg_id}};
        foreach my $disease(@disease_genes){
             print $O2 "$ensg_id\t$disease\n";
        }
    }
}

