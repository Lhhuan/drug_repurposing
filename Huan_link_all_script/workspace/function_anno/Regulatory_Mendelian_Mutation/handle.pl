#把数据整理成我们统一的格式。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1  ="./3_UTR_mutation.txt";
my $f2  ="./5_UTR_mutation.txt";
my $f3  ="./imprinting_control_region_mutations.txt";
my $f4  ="./micro_RNA_gene_mutations.txt";
my $f5  ="./promoter_enhancer.txt";
my $f6  ="./RNA_gene_mutation.txt";
my $fo = "./function_annotation.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $I6, '<', $f6 or die "$0 : failed to open input file '$f6' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;

while(<$I1>)
{
   chomp;
   unless(/^Chr/){
       my @f = split/\t/;
       my $chr = $f[0];
       my $pos = $f[1];
       my $gene = $f[5];
       my $pmid = $f[6];
       print "$pmid\t$chr:$pos\tRegulatory Mendelian Mutation\tNA\t3'UTR mutation of $gene\tNA\tNA\tNA\n";
   }
}

while(<$I2>)
{
   chomp;
   unless(/^Chr/){
       my @f = split/\t/;
       my $chr = $f[0];
       my $pos = $f[1];
       my $gene = $f[5];
       my $pmid = $f[6];
       print "$pmid\t$chr:$pos\tRegulatory Mendelian Mutation\tNA\t5'UTR mutation of $gene\tNA\tNA\tNA\n";
   }
}

while(<$I3>)
{
   chomp;
   unless(/^Chr/){
       my @f = split/\t/;
       my $chr = $f[0];
       my $pos = $f[1];
       my $gene = $f[5];
       my $pmid = $f[6];
       print "$pmid\t$chr:$pos\tRegulatory Mendelian Mutation\tNA\timprinting control region mutations of $gene\tNA\tNA\tNA\n";
   }
}

while(<$I4>)
{
   chomp;
   unless(/^Chr/){
       my @f = split/\t/;
       my $chr = $f[0];
       my $pos = $f[1];
       my $gene = $f[5];
       my $pmid = $f[6];
       print "$pmid\t$chr:$pos\tRegulatory Mendelian Mutation\tNA\tmicro RNA gene mutations of $gene\tNA\tNA\tNA\n";
   }
}

while(<$I5>)
{
   chomp;
   unless(/^Chr/){
       my @f = split/\t/;
       my $chr = $f[0];
       my $pos = $f[1];
       my $gene = $f[5];
       my $pmid = $f[6];
       print "$pmid\t$chr:$pos\tRegulatory Mendelian Mutation\tNA\tpromoter enhancer of $gene\tNA\tNA\tNA\n";
   }
}

while(<$I6>)
{
   chomp;
   unless(/^Chr/){
       my @f = split/\t/;
       my $chr = $f[0];
       my $pos = $f[1];
       my $gene = $f[5];
       my $pmid = $f[6];
       print "$pmid\t$chr:$pos\tRegulatory Mendelian Mutation\tNA\tRNA gene mutation of $gene\tNA\tNA\tNA\n";
   }
}


     


