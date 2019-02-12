# ../output/unique_cancer_oncotree.txt 和../data/CCLE_sample_info_file_2012-10-18.txt 得../output/01_merge_sample_info_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../output/unique_cancer_oncotree.txt";
my $f2 ="../data/CCLE_sample_info_file_2012-10-18.txt";
my $fo1 ="../output/01_merge_sample_info_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);

my $output ="CCLE_name\tCell_line_primary_name\tSite_Primary\tHistology\tHist_Subtype1\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID";
print  $O1 "$output\n";


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^Site/){
        my $Site_Primary = $f[0];
        my $Histology = $f[1];
        my $Hist_Subtype1 = $f[2];
        my $k = "$Site_Primary\t$Histology\t$Hist_Subtype1";
        my $oncotree_ID = join ("\t",@f[-4..-1]);
        unless($oncotree_ID =~/NA/){
            $hash1{$k}=$oncotree_ID;
        }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^CCLE/){
        my $CCLE_name = $f[0];
        my $Cell_line_primary_name = $f[1];
        my $Site_Primary = $f[4];
        my $Histology = $f[5];
        my $Hist_Subtype1 = $f[6];
        my $k = "$Site_Primary\t$Histology\t$Hist_Subtype1";
        if (exists $hash1{$k}){
            # print STDERR "$cancer\n";
            my $oncotree_ID = $hash1{$k};
            my $output = "$CCLE_name\t$Cell_line_primary_name\t$k\t$oncotree_ID";
            unless(exists $hash2{$output}){
                $hash2{$output}=1;
                print $O1 "$output\n";
            }
        }
        else{
            print STDERR "$k\n";
        }
    }
}




close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
