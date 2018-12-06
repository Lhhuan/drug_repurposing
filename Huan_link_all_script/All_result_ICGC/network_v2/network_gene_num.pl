#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

#给network_gene.txt的gene进行编号,得文件network_gene_num.txt

my $f1 ="./all_network_symbol_to_entrez.txt";
my $fo1 ="./network_gene_num.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;
print "gene_symbol\tentrez\tid\n";

my $i=0; 
while(<$I1>)
{
    unless(/^gene_symbol/){
        chomp;
        $i=$i+1;
        print "$_\t$i\n";
    }
     
}

