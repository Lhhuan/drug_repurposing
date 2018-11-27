#提取文件all_level_somatic_snv_indel_gene.vcf的mutation id,gene及genelevel得文件07_somatic_snv_indel_mutationID_gene_geneLevel.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./all_level_somatic_snv_indel_gene.vcf";
my $fo1 = "./07_somatic_snv_indel_mutationID_gene_geneLevel.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Mutation_ID\tGene\tMap_to_gene_level\n";
while(<$I1>)
{
    chomp;
    unless (/^#/){
        my @f = split/\t/;
        my $mutation_ID = $f[0];
        my $gene = $f[3];
        my $Map_to_gene_level =$f[14];
        my $output = "$mutation_ID\t$gene\t$Map_to_gene_level";
        unless(exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
     }
}
