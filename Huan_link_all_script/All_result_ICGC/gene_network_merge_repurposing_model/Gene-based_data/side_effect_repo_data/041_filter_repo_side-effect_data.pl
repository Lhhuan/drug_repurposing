#04_merge_repo_side-effect_withdrawn_data.txt中，有的同一药物，对于某一疾病既是repo，也是side effect (如：sorafenib对skin),把这种的信息去掉得041_true_repo_side-effect_data.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./04_merge_repo_side-effect_withdrawn_data.txt";
my $fo1 ="./041_true_repo_side-effect_data.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "drug\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\tside-effect_or_repo\n";
my (%hash1,%hash2);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drug= $f[0];
        my $oncotree_main_ID = $f[4];
        my $side_effect_or_repo =$f[5];
        my $k1 = "$drug\t$oncotree_main_ID";
        my $k2 = "$k1\t$side_effect_or_repo";
        push @{$hash1{$k1}},$side_effect_or_repo;
        push @{$hash2{$k2}},$_;
    }
}

foreach my $drug_cancer(sort keys %hash1){
    my @side_effect_or_repos = @{$hash1{$drug_cancer}};
    my %hash3;
    @side_effect_or_repos = grep { ++$hash3{$_} < 2 } @side_effect_or_repos; #数组内元素去重
    my $num = @side_effect_or_repos ;
    if($num eq 1){ #判断drug 对某一cancer只有一种作用，repo或者side effect
        my $k2 = "$drug_cancer\t$side_effect_or_repos[0]";
        if (exists $hash2{$k2}){ #如果drug 对某一cancer只有一种作用，把其在原表格中的信息取出来。
            my @v2s = @{$hash2{$k2}};
            foreach my $v2(@v2s){
                print $O1 "$v2\n";
            }
        }
    }
}