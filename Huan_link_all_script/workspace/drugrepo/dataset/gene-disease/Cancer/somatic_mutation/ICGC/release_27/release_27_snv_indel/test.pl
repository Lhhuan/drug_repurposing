#测试uniq_all_level_cancer_gene.txt比gencode.v19.protein_coding.bed多出来的gene 得test_protein_coding.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;
my $f1 ="./uniq_all_level_cancer_gene.txt";
my $f2 ="./gencode.v19.protein_coding.bed";
my $fo1 = "./test_protein_coding.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2);

while(<$I1>)
{
   chomp;
   unless(/^Gene/){
      my $gene =$_;
      $hash1{$gene}=1;
   } 
}

while(<$I2>)
{
   chomp;
   my @f= split/\t/;
   my $gene= $f[3];
   $hash2{$gene}=1;
}

foreach my $gene (sort keys %hash1){
    unless(exists $hash2{$gene}){
        print $O1 "$gene\n";
    }
}