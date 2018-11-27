#判断"./output/004_merge_two_source_drug_cancer_info.txt"
#中的drug target和cancer gene是否是同一基因，得01_drug_taregt_cancer_gene_same.txt,得drug target和cancer gene 完全不相同的文件01_drug_taregt_cancer_gene_differ.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
#-------------------------------------------------------------------------------------- 判断"./output/004_merge_two_source_drug_cancer_info.txt
my $f1 ="./output/004_merge_two_source_drug_cancer_info.txt";
my $fo1 ="./output/01_drug_taregt_cancer_gene_same.txt"; 
my $fo2 ="./output/01_drug_taregt_cancer_gene_differ.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $header = "Drug_claim_primary_name\tgene_symbol\tEntrez_id\tmoa\tENSG_ID\tdrug_type\tDrug_target_score\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\tside-effect_or_repo";
$header = "$header\tCADD_score\tmutation_id\tcancer_ensg\tmap_to_gene_level\tcancer_Entrez_id\tcancer_specific_affected_donors\trole_in_cancer";
print $O1 "$header\n";
print $O2 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug_claim_primary_name= $f[0];
        my $drug_Entrez_id = $f[2];
        my $drug_ENSG = $f[5];
        my $oncotree_main_ID = $f[10];
        my $cancer_ensg =$f[14];
        my $cancer_Entrez_id = $f[16];
        my $k = "$Drug_claim_primary_name\t$oncotree_main_ID";
        push @{$hash2{$k}},$_;
        if ($drug_ENSG eq $cancer_ensg){  #先用ensg 比较
            print $O1 "$_\n";
            $hash1{$k}=1;
        }
        else{
            if($drug_Entrez_id eq $cancer_Entrez_id){ #再用Entrez比较
                print $O1 "$_\n";
                $hash1{$k}=1;
            }
        }
    }
}

foreach my $drug_cancer (sort keys %hash2){  #全部的cancer gene 和drug target都不相同的 drug cancer
    unless (exists $hash1{$drug_cancer}){
        my @infos = @{$hash2{$drug_cancer}};
        foreach my $info(@infos){
            unless(exists $hash4{$info}){
                $hash4{$info}=1;
                print $O2 "$info\n";
            }
        }
    }
}