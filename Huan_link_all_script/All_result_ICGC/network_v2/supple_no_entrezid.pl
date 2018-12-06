#network_symbol_to_entrez.txt中不包括network_gene.txt中的全部基因，没有entrez的基因用symbol代替。得文件all_network_symbol_to_entrez.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./network_gene.txt";
my $f2 ="./network_symbol_to_entrez.txt";
my $fo1 ="./all_network_symbol_to_entrez.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "gene_symbol\tentrezgene\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Gene1/){
         my $gene = $f[0];
         $hash1{$gene}=1;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^query/){
         my $gene_sym = $f[0];
         my $entrezgene = $f[1];
         unless($hash2{$gene_sym}){
             $hash2{$gene_sym}=$entrezgene;
         }
     }
}

foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $entrezgene = $hash2{$ID};
        my $p = "$ID\t$entrezgene";
        print $O1 "$p\n";
    } 
    else{  #没有entrezid的基因用原来的基因填充。
        my $p = "$ID\t$ID";
        print $O1 "$p\n";
    }
}

            



