#将./output/mtctscan_all_need_info_only_sensitivity.txt和./output/mtctscan_all_need_info_only_sensitivity_uni_cancer_Oncotree.txt merge在一起，
#得./output/02_merge_mtctscan_all_sensitivity_oncotree.txt 

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/mtctscan_all_need_info_only_sensitivity_uni_cancer_Oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./output/mtctscan_all_need_info_only_sensitivity.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/02_merge_mtctscan_all_sensitivity_oncotree.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;

while(<$I1>)
{
    chomp;
    my $line_info = $_;
    $line_info =~ s/"//g;
    my @f= split /\t/,$line_info;
    my $cancer =$f[0];
    my $oncotree_detail_term = $f[1];
    my $oncotree_detail_ID = $f[2];
    my $oncotree_main_term = $f[3];
    my $oncotree_main_ID = $f[4];
    my $v= join("\t",@f[1..4]);
    unless($oncotree_detail_term =~ /oncotree_detail_term/){
        push @{$hash1{$cancer}},$v;   
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if (/^drug/){
        print $O1 "$_\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\n";
    }
    else{
        my $cancer = $f[16];
        $cancer =lc ($cancer);
        $cancer =~ s/_/ /g;
        if (exists $hash1{$cancer}){
            my @vs = @{$hash1{$cancer}};
            foreach my $v(@vs){
                my $output = "$_\t$v";
                print $O1 "$output\n";
            }
        }
        else{
            print STDERR "$cancer\n";
        }
    }
}
