#把./output/01_23928289_unique_cancer_oncotree.txt 和 ./output/01_handle_23928289repo.txt merge 在一起，得./output/02_23928289_repo_cancer.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/01_23928289_unique_cancer_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/01_handle_23928289repo.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/02_23928289_repo_cancer.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);
print $O1 "drug\trepo_cancer\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\n";


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Cancer/){
        my @f =split/\t/;
        my $cancer = $f[0];
        my $oncotree_detail_term = $f[1];
        my $oncotree_detail_ID = $f[2];
        my $oncotree_main_term =$f[3];
        my $oncotree_main_ID =$f[4];
        my $v = join ("\t",@f[1..4]);
        $hash1{$cancer}=$v;
        
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug/){
        my @f =split/\t/;
        my $Drug = $f[0];
        my $repo_cancer = $f[1];
        if (exists $hash1{$repo_cancer}){
            my $v= $hash1{$repo_cancer};
            my $output = "$Drug\t$repo_cancer\t$v";
            print $O1 "$output\n";
        }
        
    }
}
