#把unique_05_out_gene.txt转成bed文件，得06_normal_unique_01_out_gene_varint.bed
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./05_mutation_out_protein_coding_map_gene.vcf";
my $fo1 = "./06_normal_unique_05_out_gene_varint.bed";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);


while(<$I1>)
{
    chomp;
    my @f =split/\s+/;
    unless(/^#/){
        my $k =join ("\t",@f[0..13]);
        my $region = $f[1];
        my @f1 = split/\:/,$region;
        my $chr =$f1[0];
        my $region1= $f1[1];
        my @f2 = split/\-/,$region1;
        my $num = @f2;
        if ($num==1){
            my $start =$f2[0]-1;
            my $end = $f2[0];
            print $O1 "$chr\t$start\t$end\t$k\n";
        }
        else{
            my $start =$f2[0]-1;
            my $end = $f2[1];
            print $O1 "$chr\t$start\t$end\t$k\n";
        }
    }
    
}


