#将../output/01_dbNSFP_snv_vep_huan.vcf中包含../output/07_merge_three_source_gene_ensg.txt 基因的所在行筛选出来。得./08_snv_gene_in_cancer_gene.vcf,得对应的missense文件是./08_snv_gene_in_cancer_gene_missense.vcf
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../output/07_merge_three_source_gene_ensg.txt";
my $f2 ="../output/01_dbNSFP_snv_vep_huan.vcf";
my $fo1 ="./08_snv_gene_in_cancer_gene.vcf"; 
my $fo2 ="./08_snv_gene_in_cancer_gene_missense.vcf"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Gene_symbol/){
        my $ensg = $f[-1];
        $hash1{$ensg}=1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
    if (/^#/){
        unless(/^#Uploaded_variation/){
            print $O1 "$_\n";
            print $O2 "$_\n";
        }
    }
    else{
        my $ensg = $f[3];
        my $Consequence =$f[6];
        if (exists $hash1{$ensg}){
            print $O1 "$_\n";
            if ($Consequence =~ /missense_variant/){
                print $O2 "$_\n";
            }
        }
    }
}