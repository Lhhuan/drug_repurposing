#统计07_somatic_snv_indel_mutationID_gene_geneLevel.txt中 map to gene level 的每个level的mutation的数目，得count_number_of_mutation_map_to_per_level.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./07_somatic_snv_indel_mutationID_gene_geneLevel.txt";
my $fo1 = "./count_number_of_mutation_map_to_per_level.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2);
print $O1 "map_to_gene_level\tmutation_number\tpercentage\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Mutation_ID|Uploaded_variation/){
        my @f =split/\t/;
        my $Mutation_ID = $f[0];
        my $Map_to_gene_level = $f[2];
        push @{$hash1{$Map_to_gene_level}},$Mutation_ID;
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
    my $percentage = $m_number/6335265 *100;
    $percentage=sprintf "%.2f",$percentage; #四舍五入保留四位小数

    print $O1 "$level\t$m_number\t${percentage}\%\n";
}
