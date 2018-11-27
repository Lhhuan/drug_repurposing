#把./output/003_merge_repo_drug_cancer_gene.txt 和"/f/mulinlab/huan/All_result_ICGC/Gene-based_drug_R_or_S_optimization/side_effect_repo_data/06_merge_repo_side-effect_cancer_gene.txt" 
#merge 成一个文件，得./output/004_merge_two_source_drug_cancer_info.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/Gene-based_drug_R_or_S_optimization/side_effect_repo_data/06_merge_repo_side-effect_cancer_gene.txt";
my $f2 ="./output/003_merge_repo_drug_cancer_gene.txt";
my $fo1 ="./output/004_merge_two_source_drug_cancer_info.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "Drug_claim_primary_name\tgene_symbol\tEntrez_id\tmoa\tENSG_ID\tdrug_type\tDrug_target_score\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\tside-effect_or_repo";
$header = "$header\tCADD_score\tmutation_id\tcancer_ensg\tmap_to_gene_level\tcancer_Entrez_id\tcancer_specific_affected_donors\trole_in_cancer";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
       print $O1 "$_\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
       my $Drug_claim_primary_name =$f[0];
       my $gene_symbol = $f[1];
       my $Entrez_id = $f[2];
       my $moa = $f[3];
       my $ENSG_ID = $f[4];
       my $drug_type = $f[5];
       my $Drug_target_score = $f[6];
       my $oncotree_main_ID = $f[7];
       my $status = $f[8];

       my $CADD_score = $f[9];
       my $mutation_id = $f[10];
       my $cancer_ensg = $f[11];
       my $map_to_gene_level = $f[12];
       my $cancer_Entrez_id = $f[13];
       my $cancer_specific_affected_donors = $f[14];
       my $role_in_cancer = $f[15];
       my $druginfo =join("\t",@f[0..6]);
       my $cancer_gene_info = join("\t",@f[9..15]);
       my $output = "$druginfo\tNA\tNA\tNA\t$oncotree_main_ID\t$status\t$cancer_gene_info";
       unless(exists $hash1{$output}){
           $hash1{$output} =1;
           print $O1 "$output\n";
       }
    }
}
