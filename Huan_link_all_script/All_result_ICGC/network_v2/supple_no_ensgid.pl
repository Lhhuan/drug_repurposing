#network_symbol_to_ensg.txt中不包括network_gene.txt中的全部基因，没有ensg的基因用symbol代替。得文件all_network_symbol_to_ensg.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./network_gene.txt";
my $f2 ="./network_symbol_to_ensg.txt";
my $fo1 ="./all_network_symbol_to_ensg.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "gene_symbol\tensg\n"; 
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
         my $ensg_id = $f[4];
         $ensg_id =~ s/"list\(gene//g;
         $ensg_id =~ s/\s+//g;
         $ensg_id =~ s/"//g;
         $ensg_id =~ s/\)//g;
         $ensg_id =~ s/\(//g;
         $ensg_id =~ s/\=//g;
         $ensg_id =~ s/c//g;
         my @e = split/,/,$ensg_id;
         my $ensg = $e[0];
         unless($ensg =~/NA/){
             $hash2{$gene_sym}=$ensg;
         }
     }
}





foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $ensg = $hash2{$ID};
        my $p = "$ID\t$ensg";
        print $O1 "$p\n";
    } 
    else{  #没有entrezid的基因用原来的基因填充。
        my $p = "$ID\t$ID";
        print $O1 "$p\n";
    }
}

            



