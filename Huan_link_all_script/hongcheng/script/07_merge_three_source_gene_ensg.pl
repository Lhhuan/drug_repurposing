#将../output/05_three_source_gene_refine.txt 和../output/06_entrez_transform_ensg.txt merge到一起得../output/07_merge_three_source_gene_ensg.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../output/06_entrez_transform_ensg_refine.txt";
my $f2 ="../output/05_three_source_gene.txt";
my $fo1 ="../output/07_merge_three_source_gene_ensg.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Gene_symbol\tEntrez\tTumour_Types\tRole_in_Cancer\tSource\tENSG\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^entrezgene/){
        unless(defined $f[1]){
        $f[1] = "NONE";
        }
        unless($f[1]=~/\w/){$f[1]="NULL";}
        my $entrezgene = $f[0];
        my $ensg = $f[1];
        $ensg =~s/c\("//g;
        $ensg =~s/"//g;
        $ensg =~s/,.*$//g;
        $hash1{$entrezgene}=$ensg;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Gene_symbol/){
        my $Gene_symbol = $f[0];
        my $Entrez = $f[1];
        if (exists $hash1{$Entrez}){
            my $ensg = $hash1{$Entrez};
            my $output = "$_\t$ensg";
            print $O1 "$output\n";
        }
        else{
            print $O1 "$Entrez\n";
        }
    }
}