#把在01_mutation_out_protein_coding_map_gene.vcf中存在，但是在02_connect_out_gene_varint_enhancer_target.bed中不存在的突变过滤出来，得文件03_mutation_out_enhancer_target.vcf,
#同时把02_connect_out_gene_varint_enhancer_target.bed输出成元vcf文件，只是在其后面追加gene的信息，得文件03_mutation_in_enhancer_target.vcf
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./01_mutation_out_protein_coding_map_gene.vcf";
my $f2 = "./02_connect_out_gene_varint_enhancer_target.bed";
my $fo1 = "./03_mutation_in_enhancer_target.vcf";
my $fo2 = "./03_mutation_out_enhancer_target.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

print $O1 "Uploaded_variation\tLocation\tAllele\tGene\tFeature\tFeature_type\tConsequence\tcDNA_position\tCDS_position\tProtein_position\tAmino_acids\tCodons\tExisting_variation\tExtra\tMap_to_gene_level\tgene_score\tgene_source\n";


while(<$I1>)
{
    chomp;
    unless (/^#/){
        
         my @f =split/\s+/;
         my $Extra = $f[13];
         my $variation_id = $f[0];
         my $location = $f[1];
         push @{$hash1{$variation_id}},$_;
     }
}


while(<$I2>)
{
    chomp;
    my @f =split/\t/;
    my $mutation_id =$f[10];
    my $new_gene = $f[4];
    my $gene_score = $f[5];
    my $gene_source =$f[6];
    $hash2{$mutation_id}=1;
    my $location = $f[11];
    my $allele = $f[12];
    my $Extra = $f[23];
    my @f1= split/;/,$Extra;
    foreach my $i(@f1){
        if($i=~/HGVSg/){
            my $out ="$mutation_id\t$location\t$allele\t$new_gene\t-\t-\t-\t-\t-\t-\t-\t-\t-\t$i\tlevel2_enhancer_target\t$gene_score\t$gene_source";
            $hash1{$mutation_id} =$out;
            print $O1 "$out\n";
        }
    }
}

foreach my $k (sort keys %hash1){
    unless(exists $hash2{$k}){
        unless(exists $hash4{$k}){
            $hash4{$k}=1;
            print $O2 "$k\n";
        }
    }
}
