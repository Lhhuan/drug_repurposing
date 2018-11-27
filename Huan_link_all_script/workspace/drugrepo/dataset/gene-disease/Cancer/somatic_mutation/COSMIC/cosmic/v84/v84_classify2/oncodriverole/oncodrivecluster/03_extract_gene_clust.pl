#把文件01_gene_variant_type.txt中mutation和truncating_mutations 的特定类型筛选出来
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../01_cosmic_coding_path_info.txt";
my $f2 ="./oncodriveclust-results.tsv";
#my $fo1 = "./03_gene_clust.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
#open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#select $O1;
print "ENSG_ID\tsymbol\tvariant_type\n";   

my (%hash1,%hash2);
               
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^position/){
         my $position = $f[0];
         my $gene = $f[3];
         my $transcript = $f[4];
         my $ct = $f[5];
         my $symbol = $f[6];
         my $Sample = $f[7];
         my $CDS_position = $f[8];
         my $Protein_position = $f[9];
         my $v = "$gene\t$symbol\t$ct";
         push @{$hash1{$symbol}},$v;
         
     }
}                    

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^GENE/){
         my $symbol = $f[0];
         my $MUTS_IN_CLUST = $f[4];
         unless ($MUTS_IN_CLUST =~/NA/){
             $hash2{$symbol} = 1;
  
         }
     }
}                    

foreach my $ID (sort keys %hash1){ #gain
    if (exists $hash2{$ID}){
        my @value = @{$hash1{$ID}};
        foreach my $v (@value){
            print  "$v\n";
        }
    
    }
    
}

