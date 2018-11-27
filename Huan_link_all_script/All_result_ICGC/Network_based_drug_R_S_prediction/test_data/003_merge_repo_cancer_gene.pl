#用../../pathogenicity_mutation_cancer/pathogenicity_mutation_cancer.txt 将./output/002_drug_info_repo.txt中cancer 相关信息提出来，得./output/003_merge_repo_drug_cancer_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/002_drug_info_repo.txt";
my $f2 ="../../pathogenicity_mutation_cancer/pathogenicity_mutation_cancer.txt";
my $fo1 ="./output/003_merge_repo_drug_cancer_gene.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header = "Drug_claim_primary_name\tgene_symbol\tEntrez_id\tmoa\tENSG_ID\tdrug_type\tDrug_target_score\toncotree_main_ID\tstatus";
$header = "$header\tCADD_score\tmutation_id\tcancer_ensg\tmap_to_gene_level\tcancer_Entrez_id\tcancer_specific_affected_donors\trole_in_cancer";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $cancer_oncotree_main_ID =$f[-2];
        push @{$hash1{$cancer_oncotree_main_ID}},$_;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^CADD/){
        my $CADD_score= $f[0];
        my $cancer_oncotree_main_ID = $f[-2];
        my $mutation_id = $f[1];
        my $cancer_ensg=$f[2];
        my $map_to_gene = $f[3];
        my $cancer_Entrez_id = $f[4];
        my $cancer_specific_affected_donors = $f[6];
        my $role_in_cancer =$f[-1];
        my $v = "$CADD_score\t$mutation_id\t$cancer_ensg\t$map_to_gene\t$cancer_Entrez_id\t$cancer_specific_affected_donors\t$role_in_cancer";
        push @{$hash2{$cancer_oncotree_main_ID}},$v;
    }
}

foreach my $cancer_oncotree_main_ID(sort keys %hash1){
    my @drug_infos = @{$hash1{$cancer_oncotree_main_ID}};
    if(exists $hash2{$cancer_oncotree_main_ID}){
        my @cancer_infos= @{$hash2{$cancer_oncotree_main_ID}};
        foreach my $drug_info(@drug_infos){
            foreach my $cancer_info(@cancer_infos){
                print $O1 "$drug_info\t$cancer_info\n";
            }
        }
    }
}
