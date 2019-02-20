#统计cancer_id_full_oncotree1.txt 中每个main tissue 中project的数目，得count_main_tissue_cancer_project.txt,统计每个detail tissue中的project的数目，得count_main_detail_cancer_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./cancer_id_full_oncotree1.txt";
my $fo1 = "./count_detail_tissue_cancer_project.tsv";
my $fo2 = "./count_main_cancer_project.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2);
print $O1 "cancer\tproject_number\n";
print $O2 "cancer\tproject_number\n";
while(<$I1>)
{
    chomp;
    my $info = $_;
    $info =~s/"//g;
    my @f= split/\t/,$info;
    unless (/^term/){
        my @f =split/\t/;
        my $project = $f[1];
        my $oncotree_term_detail = $f[5];
        my $oncotree_term_detail_ID = $f[6];
        my $oncotree_term_main_tissue = $f[7];
        push @{$hash1{$oncotree_term_detail}},$project;
        push @{$hash2{$oncotree_term_main_tissue}},$project;
    }
}

foreach my $detail(sort keys %hash1){
    my @projects = @{$hash1{$detail}};
    my %hash3;
    @projects = grep { ++$hash3{$_} < 2 } @projects; #对数组内元素去重
    my $p_number = @projects;
    print $O1 "$detail\t$p_number\n";
}

foreach my $main(sort keys %hash2){
    my @projects = @{$hash2{$main}};
    my %hash4;
    @projects = grep { ++$hash4{$_} < 2 } @projects; #对数组内元素去重
    my $p_number = @projects;
    print $O2 "$main\t$p_number\n";
}