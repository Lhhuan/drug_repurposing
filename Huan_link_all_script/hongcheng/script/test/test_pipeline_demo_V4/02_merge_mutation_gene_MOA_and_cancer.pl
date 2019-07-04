#将./output/01_merge_missense_and_lof_vraint_moa.txt 和"/f/mulinlab/huan/hongcheng/output/10_normal_three_source_cancer_gene_lable.txt" merge 到一起，
#得./output/02_merge_mutation_gene_MOA_and_cancer.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/hongcheng/output/10_normal_three_source_cancer_gene_lable.txt";
my $f2 ="./output/01_merge_missense_and_lof_vraint_moa.txt";
# my $f2 ="./output/01_merge_missense_and_lof_vraint_moa_test.txt";
my $fo1 ="./output/02_merge_mutation_gene_MOA_and_cancer.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Variant_id\tENSG\tConsequence\tProtein\tB_sift_score\tmutation_to_gene_moa\tEntrez\tTumour_Types\tcancer_gene_normal_MOA\tMOA_rule\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);


while(<$I1>)
{
    chomp;
    unless(/^Gene_symbol/){
        my @f= split /\t/;
        my $Entrez = $f[1];
        my $Tumour_Types = $f[2];
        my $Role_in_Cancer = $f[3];
        my $ENSG = $f[4];
        my $normal_MOA = $f[5];
        my $MOA_rule = $f[6];
        my $v= "$Entrez\t$Tumour_Types\t$normal_MOA\t$MOA_rule";
        push @{$hash1{$ENSG}},$v;
    }
}


while(<$I2>)
{
    chomp;
    unless(/^Variant_id/){
        my @f= split /\t/;
        my $Variant_id = $f[0];
        my $ENSG = $f[1];
        my $Consequence = $f[2];
        my $Protein = $f[3];
        my $B_sift_score = $f[4];
        my $mutation_to_gene_moa = $f[-1];
        if (exists $hash1{$ENSG}){
            my @vs = @{$hash1{$ENSG}};
            foreach my $v(@vs){
                my $output = "$Variant_id\t$ENSG\t$Consequence\t$Protein\t$B_sift_score\t$mutation_to_gene_moa\t$v";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
        else{
            print "$ENSG\n";
        }
    }
}
