#把11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt，去掉drug和cancer后去重输出，得12_unique_repo_withdrwal_data_for_logistic_regression.txt
use warnings;
use strict; 
use utf8;



my $f1 ="./11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt";
my $fo1 ="./12_unique_repo_withdrwal_data_for_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $out = join("\t",@f[2..11]);
    if (/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$out\n";
    }
    else{
        unless(exists $hash1{$out}){
            $hash1{$out} =1;
            print $O1 "$out\n";
        }
    }
}