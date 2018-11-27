#把四个数据01_mutation_in_protein_coding_map_gene.vcf, 03_mutation_in_enhancer_target.vcf,05_varint_gene_in_level3_1.vcf, 063_normalized_mutation_to_gene_level3_2.txt
#读到一起，然后统一的用split分割，得all_level_somatic_snv_indel_gene.vcf
#!/usr/bin/perl
use warnings;
use strict;
use utf8;
my $f1 ="./01_mutation_in_protein_coding_map_gene.vcf";
my $f2 ="./03_mutation_in_enhancer_target.vcf";
my $f3 ="./05_varint_gene_in_level3_1.vcf";
my $f4 ="./063_normalized_mutation_to_gene_level3_2.txt";
my $fo1 = "./all_level_somatic_snv_indel_gene.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

#Uploaded_variation     Location        Allele  Gene    Feature Feature_type    Consequence     cDNA_position   CDS_position    Protein_position        Amino_acids     Codons  Existing_variation      Extra   Map_to_gene_level
my $header ="#Uploaded_variation\tLocation\tAllele\tGene\tFeature\tFeature_type\tConsequence\tcDNA_position\tCDS_position\tProtein_position\tAmino_acids\tCodons\tExisting_variation\tExtra\tMap_to_gene_level\tscore\tsource";

print $O1 "$header\n";
while(<$I1>)
{
   chomp;
   unless(/^#/){
       my @f = split/\s+/;
       my $out = join ("\t",@f[0..14]);
      print $O1 "$out\tNA\tNA\n";
   } 
}

while(<$I2>)
{
   chomp;
   unless(/^#/){
       print $O1 "$_\n";
   }
}

while(<$I3>)
{
   chomp;
   unless(/^#/){
       my @f = split/\s+/;
       my $out = join ("\t",@f[0..14]);
       print $O1 "$out\tNA\tNA\n";
   } 
}

while(<$I4>)
{
   chomp;
   unless(/^#/){
       print $O1 "$_\tNA\tNA\n";
   }
}