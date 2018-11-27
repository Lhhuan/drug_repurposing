#把gencode.v19.annotation.gff3中gene_type为protein_coding的gene筛选出来。得文件protein_coding_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./gencode.v19.annotation.gff3";
my $fo1 = "./gene_type.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Gene\tgene_type\n";
while(<$I1>)   #提取出所有的gene和gene type
{
    chomp;
    unless (/^#/){
        my @f = split/\s+/;
        my $info = $f[8];
        my @f1 = split/\;/,$info;
        foreach my $i(@f1){
            if($i =~/^gene_id/){
                my @f2 = split/\=/,$i;
                my $ensg= $f2[1];
                $ensg=~s/\..*$//g;
            #     print STDERR "$ensg\n";
               print $O1 "$ensg\t";
            }
            elsif($i =~/^gene_type/){
                my @f2 = split/\=/,$i;
                my $type =$f2[1];
                print $O1 "$type\n";
            }
        }
      
     }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";


my $f2 = "./gene_type.txt";
my $fo2 = "./protein_coding_gene.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O2 "Gene\tgene_type\n";

while(<$I2>)  #把gene_type是protein_coding过滤出来
{
    chomp;
    unless (/^Gene/){
        my @f = split/\s+/;
        my $gene= $f[0];
        my $type = $f[1];
        if ($type=~/^protein_coding$/){
            my $out = "$gene\t$type";
            unless(exists $hash1{$out}){
                $hash1{$out} =1;
                print $O2 "$out\n";
            }
        }
      
     }
}