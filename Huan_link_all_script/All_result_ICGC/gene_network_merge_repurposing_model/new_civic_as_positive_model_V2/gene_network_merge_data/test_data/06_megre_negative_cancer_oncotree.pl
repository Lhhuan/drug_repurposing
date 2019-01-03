#将./output/05_uniqie_negative_cancer_oncotree.txt和./output/05_filter_cancer_from_repoDB_negative.txt merge到一起，得./output/06_megre_negative_cancer_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/05_uniqie_negative_cancer_oncotree.txt";
my $f2 ="./output/05_filter_cancer_from_repoDB_negative.txt";
my $fo1 ="./output/06_megre_negative_cancer_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
print  $O1 "oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^disease/){
        my $cancer = $f[0];
        my $oncotree_main_tissue_ID = $f[4];
        my $oncotree_ID = join ("\t",@f[1..4]);
        unless($oncotree_main_tissue_ID =~/NA/){
            $hash1{$cancer}=$oncotree_ID;
        }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^drug/){
        my $drug =$f[0];
        my $cancer = $f[1];
        if (exists $hash1{$cancer}){
            # print STDERR "$cancer\n";
            my $oncotree_ID = $hash1{$cancer};
            my $output = "$oncotree_ID\t$drug";
            unless(exists $hash2{$output}){
                $hash2{$output}=1;
                print $O1 "$output\n";
            }
        }
    }
}




close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
