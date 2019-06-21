# 从cgi中下载的catalog_of_validated_oncogenic_mutations.tsv ，看在 "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/icgc_and_add_hgvsg_before_2019.6.11.txt"
# 中有多少存在。得存在文件./output/in_icgc_add_cgi.txt 得不存在文件./output/out_icgc_add_cgi.txt ，得不存在的文件信息./output/out_icgc_add_cgi_info.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f2 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/catalog_of_validated_oncogenic_mutations.tsv";
# my $f1 = "./pathogenicity_mutation_postion_hgvsg.txt";
# my $fo1 = "./in_pathogenicity_cgi.txt";
# my $fo2 = "./out_pathogenicity_cgi.txt";
my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/icgc_and_add_hgvsg_before_2019.6.11.txt";
my $fo1 = "./output/in_icgc_add_cgi.txt";
my $fo2 = "./output/out_icgc_add_cgi.txt";
my $fo3 = "./output/out_icgc_add_cgi_info.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Mutation_ID\thgvsg\n";
# print $O2 "Mutation_ID\thgvsg\n";



while(<$I1>)
{
    chomp;
    unless (/^Mutation_ID/){
        my @f =split/\t/;
        my $hgvsg = $f[1];
        $hash1{$hgvsg}=$_;
        # print "$hgvsg\n";
    }
}

while(<$I2>)
{
    chomp;
    if (/^gene/){
        print $O3 "$_\n";
    }
    else{
        my @f = split/\t/;
        my $gdna = $f[1];
        $gdna =~s/chr//g;
        # print "$gdna\n";
        if (exists $hash1{$gdna}){
            my $v = $hash1{$gdna};
            print $O1 "$v\n";
        }
        else{
            print $O2 "$gdna\n";
            print $O3 "$_\n";
        }
    }
}