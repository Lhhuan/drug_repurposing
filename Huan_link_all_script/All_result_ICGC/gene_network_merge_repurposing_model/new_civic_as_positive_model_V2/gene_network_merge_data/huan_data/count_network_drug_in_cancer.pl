#根据 ./output/network_based_logic_true_drug_cancer_pairs.txt 计算logic true gene based 每个cancer对应了几个drug，以及总体的比例，main cancer 文件
#得./output/network_based_logic_true_drug_count_in_main_cancer.txt detail 得./output/network_based_logic_true_drug_count_in_detail_cancer.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/network_based_logic_true_drug_cancer_pairs.txt";
my $fo1 ="./output/network_based_logic_true_drug_count_in_main_cancer.txt";
my $fo2 ="./output/network_based_logic_true_drug_count_in_detail_cancer.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n"; 

my $header = "Cancer_term\tCancer_ID\tdrug_number\tall_drug_number\tpercentage";
print $O1 "$header\n";
print $O2 "$header\n";

my (%hash1,%hash2);
#network
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id_Drug_claim_primary_name/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name = $f[1];
        my $oncotree_term_detail = $f[2];
        my $oncotree_ID_detail =$f[3];
        my $oncotree_term_main_tissue = $f[4];
        my $oncotree_ID_main_tissue = $f[5];
        # print "$Drug_chembl_id_Drug_claim_primary_name\n";
        my $k1 = "$oncotree_term_main_tissue\t$oncotree_ID_main_tissue";
        my $k2 = "$oncotree_term_detail\t$oncotree_ID_detail";
        push @{$hash1{$k1}},$Drug_chembl_id_Drug_claim_primary_name;
        push @{$hash2{$k2}},$Drug_chembl_id_Drug_claim_primary_name;
    }
}

# foreach my $k(sort keys %hash1){
#     my @drugs = @{$hash1{$k}};
#     my %hash3;
#     @drugs = grep { ++$hash3{$_} < 2 } @drugs;
#     my $drug_number = @drugs;
#     my $prirs_propotion = $drug_number/5948 *100; #5948 为总药物的数目。
#     print $O1 "$k\t$drug_number\t$prirs_propotion\n";
# }

# foreach my $k(sort keys %hash2){
#     my @drugs = @{$hash2{$k}};
#     my %hash3;
#     @drugs = grep { ++$hash3{$_} < 2 } @drugs;
#     my $drug_number = @drugs;
#     my $prirs_propotion = $drug_number/5948 *100; #5948 为总药物的数目。
#     print $O2 "$k\t$drug_number\t$prirs_propotion\n";
# }
my $all_detail_count = 5948*51;
my $all_main_count = 5948*22;

my $network_based_main_overall_count =0;
foreach my $k(sort keys %hash1){
    my @drugs = @{$hash1{$k}};
    my %hash5;
    @drugs = grep { ++$hash5{$_} < 2 } @drugs;
    my $drug_number = @drugs;
    my $prirs_propotion = $drug_number/5948 *100; #5948 为总药物的数目。
    print $O1 "$k\t$drug_number\t5948\t$prirs_propotion\n";
    $network_based_main_overall_count =$network_based_main_overall_count+$drug_number;
}
my $network_based_main_overall_p = $network_based_main_overall_count/$all_main_count*100;
print $O1 "Overall\tOverall\t$network_based_main_overall_count\t$all_main_count\t$network_based_main_overall_p\n";

# #--------------------------------------------------------
my $network_based_detail_overall_count =0;
foreach my $k(sort keys %hash2){
    my @drugs = @{$hash2{$k}};
    my %hash5;
    @drugs = grep { ++$hash5{$_} < 2 } @drugs;
    my $drug_number = @drugs;
    my $prirs_propotion = $drug_number/5948 *100; #5948 为总药物的数目。
    print $O2 "$k\t$drug_number\t5948\t$prirs_propotion\n";
    $network_based_detail_overall_count =$network_based_detail_overall_count+$drug_number;
}
my $network_based_detail_overall_p = $network_based_detail_overall_count/$all_detail_count*100;
print $O2 "Overall\tOverall\t$network_based_detail_overall_count\t$all_detail_count\t$network_based_detail_overall_p\n";