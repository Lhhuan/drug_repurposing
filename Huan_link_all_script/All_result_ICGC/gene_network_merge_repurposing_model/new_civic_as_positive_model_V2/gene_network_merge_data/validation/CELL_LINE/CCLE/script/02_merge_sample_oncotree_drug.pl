#将../output/01_merge_sample_info_oncotree.txt 和../data/CCLE_NP24.2009_Drug_data_2015.02.24.txt merge 到一起，得../output/02_merge_sample_oncotree_drug.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../output/01_merge_sample_info_oncotree.txt";
my $f2 ="../data/CCLE_NP24.2009_Drug_data_2015.02.24.txt";
my $fo1 ="../output/02_merge_sample_oncotree_drug.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);



while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^CCLE_name/){
        my $CCLE_name = $f[0];
        my $Cell_line_primary_name = $f[1];
        my $k = "$CCLE_name\t$Cell_line_primary_name";
        #my $k = $CCLE_name;
        my $oncotree_ID = join ("\t",@f[-4..-1]);
        $hash1{$k} =$oncotree_ID;
    }
}

print $O1 "CCLE_name\tCell_line_primary_name\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tCompound\tEC50\tIC50\tAmax\tActArea\n";
while(<$I2>)  #snv
{
    chomp;
    my @f= split /\t/;
    unless (/^CCLE/){
        my $CCLE_name = $f[0];
        my $Cell_line_primary_name = $f[1];
        my $Compound = $f[2];
        my $EC50 = $f[-4];
        my $IC50 = $f[-3];
        my $Amax =$f[-2];
        my $ActArea =$f[-1];
        my $k = "$CCLE_name\t$Cell_line_primary_name";
        if (exists $hash1{$k}){
            my $oncotree_ID = $hash1{$k};
            my $output = "$k\t$oncotree_ID\t$Compound\t$EC50\t$IC50\t$Amax\t$ActArea";
            print $O1 "$output\n";
        }
    }
}





close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
