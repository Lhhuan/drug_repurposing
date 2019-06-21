#统计./output/pathogenicity_mutation_cancer.txt中 map to gene level 的每个level的mutation的数目，得./output/count_number_of_Pathogenic_mutation_map_to_per_level.txt
#统计gene moa, 统计每种moa 下的gene数及其比例，得./output/count_number_of_cancer_gene_MOA.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/pathogenicity_mutation_cancer.txt";
my $fo1 = "./output/count_number_of_Pathogenic_mutation_map_to_per_level.txt";
my $fo2 = "./output/count_number_of_cancer_gene_MOA.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2);
print $O1 "map_to_gene_level\tmutation_number\tpercentage\n";
print $O2 "MOA\tgene_number\tpercentage\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^CADD_MEANPHRED/){
        my @f =split/\t/;
        my $Mutation_ID = $f[1];
        my $ENSG = $f[2];
        my $Map_to_gene_level = $f[3];
        my $gene_role_in_cancer = $f[-1];
        push @{$hash1{$Map_to_gene_level}},$Mutation_ID;
        push @{$hash2{$gene_role_in_cancer}},$ENSG;
    }
}

foreach my $level(sort keys %hash1){
    my @mutations = @{$hash1{$level}};
    my %hash3;
    @mutations = grep { ++$hash3{$_} < 2 } @mutations; #对数组内元素去重
    my $m_number = @mutations;
    $level =~s/Level1_1_protein_coding/Level1.1/g;
    $level =~s/Level1_2_protein_coding/Level1.2/g;
    $level =~s/level2_enhancer_target/Level2/g;
    $level =~s/level3.1/Level3.1/g;
    $level =~s/level3.2/Level3.2/g;
    my $percentage = $m_number/85994 *100; #除以所有 p mutation 的数目 : wc -l ./output/pathogenicity_mutation_ID.txt
    $percentage=sprintf "%.2f",$percentage; #四舍五入保留四位小数
    print $O1 "$level\t$m_number\t${percentage}\%\n";
}

foreach my $MOA (sort keys %hash2){
    my @genes = @{$hash2{$MOA}};
    my %hash4;
    @genes =grep { ++$hash4{$_} < 2 } @genes; #对数组内元素去重
    my $n_number = @genes;
    my $percentage = $n_number/16292 *100;  #所有p_mutation map 到的gene数目： cat ../output/12_merge_ICGC_info_gene_role.txt| cut -f2 | sort -u | wc -l 
    $percentage=sprintf "%.2f",$percentage; #四舍五入保留四位小数
    $MOA =~s/LOF,GOF/GOF,LOF/g;
    $MOA =~s/LOF/TSG/g;
    $MOA =~s/GOF/Oncogene/g;
    print $O2 "$MOA\t$n_number\t${percentage}\%\n";
}