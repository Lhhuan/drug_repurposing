#将./output/network_gene_num.txt和./output/network_alias_to_symbol.txt merge到一起./output/network_gene_num_symbol.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/network_alias_to_symbol.txt";
my $f2 ="./output/network_gene_num.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/network_gene_num_symbol.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my %hash1;
my %hash2;


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^query/){  #entrezgene和network_id转换
        my $alias = $f[0];
        my $symbol =$f[1];
        $hash1{$alias}=$symbol;
    }
}



while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if (/^gene_symbol/){
        print $O1 "$_\tfinal_symbol\n";
    }
    else{
        my $gene_symbol = $f[0];
        if (exists $hash1{$gene_symbol}){
            my $final_symbol = $hash1{$gene_symbol};
            print $O1 "$_\t$final_symbol\n";
        }
        else{
            print "$gene_symbol\n";
        }
    }
}

