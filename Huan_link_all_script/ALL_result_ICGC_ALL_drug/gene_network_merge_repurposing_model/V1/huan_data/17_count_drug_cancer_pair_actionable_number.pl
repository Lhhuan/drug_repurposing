#用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/all_actionable_driver/output/01_all_actionable_driver_mutation.txt"
# 和./output/03_unique_merge_gene_based_and_network_based_data.txt.gz 统计不同drug cancer 中的actionable or driver mutation 的数目，得文件./output/17_drug_cancer_pairs_actionable_number.txt
#得pair的actionable文件./output/17_drug_cancer_pairs_actionable.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/all_actionable_driver/output/01_all_actionable_driver_mutation.txt";
my $f2 = "./output/03_unique_merge_gene_based_and_network_based_data.txt.gz";
my $fo1 = "./output/17_drug_cancer_pairs_actionable_number.txt";
my $fo2 = "./output/17_drug_cancer_pairs_actionable.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n"); #读压缩文件
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2);


print $O1 "Drug_chembl_id_Drug_claim_primary_name\toncotree_ID\toncotree_id_type\tactionable_mutation_number\n";
print $O2 "Drug_chembl_id_Drug_claim_primary_name\toncotree_ID\toncotree_id_type\tmutation\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Mutation_id/){
       my $Mutation_id = $f[0];
       $hash1{$Mutation_id}=1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Mutation_id/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Mutation_ID = $f[8];
        my $oncotree_ID_sub_tissue =$f[13];
        my $oncotree_ID_main_tissue =$f[14];
        unless(exists $hash1{$Mutation_ID}){
            my $k1  = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID_sub_tissue\toncotree_sub_id";
            my $k2  = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID_main_tissue\toncotree_main_id";
            push @{$hash2{$k1}},$Mutation_ID;
            push @{$hash2{$k2}},$Mutation_ID;
        }
    }
}

foreach my $k (sort keys %hash2){
    my @Mutation_IDs = @{$hash2{$k}};
    my %hash3;
    @Mutation_IDs =grep { ++$hash3{$_}<2}@Mutation_IDs;
    my $number = @Mutation_IDs;
    print $O1 "$k\t$number\n";
    foreach my $mutation(@Mutation_IDs){
        print $O2 "$k\t$mutation\n";
    }
}