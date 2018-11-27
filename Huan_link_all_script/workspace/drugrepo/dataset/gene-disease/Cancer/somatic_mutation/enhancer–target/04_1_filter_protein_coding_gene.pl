#把final_all_enhancer_target_ensg.txt中gene_type为protein_coding的基因滤出来，得final_protein_coding_all_enhancer_target_ensg.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/protein_coding_gene.txt";
my $f2 = "./final_all_enhancer_target_ensg.txt";
my $fo1 = "./final_protein_coding_all_enhancer_target_ensg.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

my $title = "region\tgene\tscore\tsource";
print $O1 "$title\n";


while(<$I1>)  #把gene_type是protein_coding过滤出来
{
    chomp;
    unless (/^Gene/){
        my @f = split/\s+/;
        my $gene= $f[0];
        $hash1{$gene}=1;
      
    }
}

while(<$I2>)   #提取出所有的gene和gene type
{
    chomp;
    unless (/^region/){
        my @f = split/\t/;
        my $gene = $f[1];
        push @{$hash2{$gene}},$_;
     }
}

foreach my $gene(sort keys %hash1){
    if (exists $hash2{$gene}){
        my @vs= @{$hash2{$gene}};
        foreach my $v(@vs){
            unless(exists $hash3{$v}){
                $hash3{$v} =1 ;
                print $O1 "$v\n";
            }
        }
    }
}