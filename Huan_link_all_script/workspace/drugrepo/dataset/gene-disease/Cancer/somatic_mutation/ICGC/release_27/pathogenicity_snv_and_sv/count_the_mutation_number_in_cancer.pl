#统计./output/merge_oncotree_all_pathogenicity_sv_cnv_project.txt中每种cancer对应的特定的mutation 的数目。得./output/snv_sv_number_in_cancer.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/merge_oncotree_all_pathogenicity_sv_cnv_project.txt";
my $fo1 = "./output/snv_sv_number_in_cancer.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;

print $O1 "oncotree_ID_main_tissue\tClass\tmutation_number\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^mutation/){
        my @f =split/\t/;
        my $mutation_id = $f[0];
        my $oncotree_ID_main_tissue = $f[-2];
        my $class= $f[-1];
        my $v = "$mutation_id\t$class";
        my $k = "$oncotree_ID_main_tissue\t$class";
        push @{$hash1{$k}},$v;
    }
}

foreach my $cancer (sort keys %hash1){
    my @mutations = @{$hash1{$cancer}};
    my %hash2;
    @mutations = grep { ++$hash2{$_} < 2 } @mutations; #对数组内元素去重
    my $number  = @mutations;
    print $O1 "$cancer\t$number\n";
}