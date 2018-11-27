
#!/usr/bin/perl

use warnings;
use strict;
my $file1 = "./data/CGD.txt";
my $file2 = "./data/interactions.tsv";
open my $file_hander1, '<', $file1 or die "$0 : failed to open input file '$file1' : $!\n";
open my $file_hander2, '<', $file2 or die "$0 : failed to open input file '$file2' : $!\n";

my @gene1 = <$file_hander1>;

while(<$file_hander2>){
  chomp;
  my $gene2_drug = (split(/\t/,$_))[4];
  my $gene2_gene = (split(/\t/,$_))[0]; 
  foreach my $gene1_line (@gene1){
    my $gene1_gene = (split(/\t/,$gene1_line))[0];
    my $gene1_disease = (split(/\t/,$gene1_line))[3];
    if($gene2_gene eq $gene1_gene){
       print $gene2_drug."\t".$gene1_disease."\t".$gene2_gene."\n";
    }
  }
}
   print "1234\n";