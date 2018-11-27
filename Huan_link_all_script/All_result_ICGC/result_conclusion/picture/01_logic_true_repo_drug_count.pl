#记录../../uniq_logic_true_repo_drug_pair.txt 里每个repo 从cancer 所对应的drug 数目，得文件logic_true_repo_drug_count.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../../20_drug_repo_cancer_logic_true.txt";
my $fo1 ="./logic_true_repo_drug_count.txt"; 

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "cancer\tdrug_num\n";

my %hash1;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^oncotree_ID/){
        my $cancer = $f[0];
        my $drug = $f[1];
        push @{$hash1{$cancer}},$drug;
     }
}

foreach my $cancer(sort keys %hash1){
    my %hash2;
    my @drug = @{$hash1{$cancer}};
    @drug = grep { ++$hash2{$_} < 2 } @drug;
    my $num = @drug;
    print $O1 "$cancer\t$num\n";
}


