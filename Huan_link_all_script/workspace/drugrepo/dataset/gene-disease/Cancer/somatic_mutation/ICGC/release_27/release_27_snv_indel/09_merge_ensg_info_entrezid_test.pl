#把07_somatic_snv_indel_mutationID_gene_geneLevel.txt 和 08_ensg_to_entrezid.txt merge在一起得文件09_somatic_snv_indel_mutationID_ensg_entrez.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./07_somatic_snv_indel_mutationID_gene_geneLevel.txt";
my $f2 = "./08_ensg_to_entrezid.txt";
my $fo1 = "./09_somatic_snv_indel_mutationID_ensg_entrez.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Mutation_ID\tGene\tMap_to_gene_level\tentrezgene\n";
while(<$I1>)
{
    chomp;
    unless (/^Mutation_ID/){
        my @f = split/\t/;
        my $mutation_ID = $f[0];
        my $ensg = $f[1];
        my $Map_to_gene_level =$f[2];
        my $output = "$mutation_ID\t$ensg\t$Map_to_gene_level";
        push @{$hash1{$ensg}},$output;
     }
}

while(<$I2>)
{
    chomp;
    unless (/^query/){
        my @f = split/\t/;
        my $ensg = $f[0];
        my $entrezgene =$f[3];
        $hash2{$ensg}=$entrezgene;
     }
}

foreach my $ensg(sort keys %hash1){
    if(exists $hash2{$ensg}){
        my @infos =@{$hash1{$ensg}};
        my $entrez = $hash2{$ensg};
        foreach my $info(@infos){
            my $output = "$info\t$entrez";
            unless(exists $hash3{$output}){
                $hash3{$output} = 1;
                print $O1 "$output\n";
            }
        }
    }
    else{
        print STDERR "$ensg\n";
        my @infos =@{$hash1{$ensg}};
        foreach my $info(@infos){
            my $output = "$info\tNA";
            unless(exists $hash3{$output}){
                $hash3{$output} = 1;
                print $O1 "$output\n";
            }
        }
    }
}


