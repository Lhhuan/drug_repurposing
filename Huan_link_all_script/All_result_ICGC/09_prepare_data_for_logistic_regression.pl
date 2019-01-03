#用08_sorted_logic_not_no_drug_cancer_infos_check.txt为做逻辑回归准备数据，得文件09_prepare_data_for_logistic_regression.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./08_sorted_logic_not_no_drug_cancer_infos_check.txt";
my $fo1 ="./09_prepare_data_for_logistic_regression.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


print $O2 "Drug_claim_primary_name\tEntrez_id\tensg\tnormal_drug_target_score\toncotree_main_ID\trepo_or_side_effect\tmutation_id\tcancer_specific_affected_donors\tlogic\n";
print $O1 "$header\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $drug = $f[0];
        my $Entrez_id = $f[1];
        my $ensg =$f[2];
        my $normal_drug_target_score =$f[3];
        my $oncotree_main_ID = $f[4]; 
        my $repo_or_side_effect = $f[5];
        my $mutation_id = $f[6];
        my $cancer_specific_affected_donors =$f[7];
        my $logic = $f[-1];
        my $
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; 
