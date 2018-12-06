#判断06_merge_repo_side-effect_cancer_gene.txt中的drug target和cancer gene是否是同一基因，得07_drug_taregt_cancer_gene_same.txt 
#然后判断07_drug_taregt_cancer_gene_same.txt的dru个MOA 和disease MOA逻辑是否一致，得07_drug_taregt_cancer_gene_same_logic.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
#-------------------------------------------------------------------------------------- 判断06_merge_repo_side-effect_cancer_gene.txt中的drug target和cancer gene是否是同一基因，得07_drug_taregt_cancer_gene_same.txt
my $f1 ="./06_merge_repo_side-effect_cancer_gene.txt";
my $fo1 ="./07_drug_taregt_cancer_gene_same.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
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
        my $drug_ensg = $f[4];
        my $drug_entrez =$f[2];
        my $cancer_ensg = $f[-5];
        my $cancer_entrez = $f[-3];
        if($drug_ensg!~/NA/ && $cancer_ensg !~/NA/){ #ensg 不为NA时， 用ensg比较drug target 和cancer gene 是否相等。
            if($drug_ensg eq $cancer_ensg ){
                unless (exists $hash1{$_}){
                    $hash1{$_} =1;
                    print $O1 "$_\n";
                }
            }
        }
        else{
            if($drug_entrez eq $cancer_entrez){ #ensg 为NA时， 用entrez比较比较drug target 和cancer gene 是否相等。
                unless (exists $hash1{$_}){
                    $hash1{$_} =1;
                    print $O1 "$_\n";
                }
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; 
#--------------------------------------------------------------------------------------------------------------
my $f2 ="./07_drug_taregt_cancer_gene_same.txt"; 
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo2 ="./07_drug_taregt_cancer_gene_same_logic.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

print $O2 "$header\tlogic\n";
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $drug_ensg = $f[4];
        my $drug_entrez =$f[2];
        my $cancer_ensg = $f[-5];
        my $cancer_entrez = $f[-3];
        my $drug_type = $f[5];
        my $Role_in_cancer = $f[-1];
        if ($Role_in_cancer=~/LOF,GOF/){ #gene role是LOF，GOF时表明gene 既有可能是lof,也有可能是GOF，所以不管drug是A和I或者both都有可能是对的，所以这里算逻辑上对
            print $O2 "$_\ttrue\n";
         }
         else{
            if($Role_in_cancer=~/LOF/){
                if($drug_type=~/A/){
                    print $O2 "$_\ttrue\n";
                }
                elsif($drug_type=~/I/){
                    print $O2 "$_\tconflict\n";
                }
                else{  #这里的unknown和both都按没有逻辑算。
                    print $O2 "$_\tno\n";
                }
            }
            elsif($Role_in_cancer=~/GOF/){
                if($drug_type=~/I/){
                    print $O2 "$_\ttrue\n";
                }
                elsif($drug_type=~/A/){
                    print $O2 "$_\tconflict\n";
                }
                else{
                    print $O2 "$_\tno\n";
                }
            }
            else{
                print $O2 "$_\tno\n";
            }
         }
    }
}