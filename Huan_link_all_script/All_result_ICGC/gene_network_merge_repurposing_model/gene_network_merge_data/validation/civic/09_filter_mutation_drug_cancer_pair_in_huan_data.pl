#从../../huan_data/output/03_final_data_for_calculate_features.txt中提取./output/08_unique_mutation_Drug_chembl_cancer_pair.txt 中的mutation_cancer_drug pair 
#得./output/09_validation_data_for_calculate_features.txt 
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/08_unique_mutation_Drug_chembl_cancer_pair.txt";
my $f2 ="../../huan_data/output/03_final_data_for_calculate_features.txt";
my $fo1 ="./output/09_validation_data_for_calculate_features.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0];
        my $Mutation_ID =$f[1];
        my $oncotree_main_tissue_id =$f[3];
        my $k = "$Mutation_ID\t$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_main_tissue_id";
        $hash1{$k}=1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$_\n";
    }
    else{
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0]; 
        my $Mutation_ID = $f[8];
        my $oncotree_main_tissue_id =$f[13];
        my $k = "$Mutation_ID\t$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_main_tissue_id";
        if (exists $hash1{$k}){
            print $O1 "$_\n";
        }
    }
}



close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
