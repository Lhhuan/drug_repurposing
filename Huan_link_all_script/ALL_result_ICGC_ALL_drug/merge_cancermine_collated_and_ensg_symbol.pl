#将./outout/cancermine_collated.tsv和./output/transfrom_cancermine_entrez_to_ensg_symbol.txt merge在一起，得./output/cancermine_collated_and_ensg_symbol.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/transfrom_cancermine_entrez_to_ensg_symbol.txt";
my $f2 ="./output/cancermine_collated.tsv";
my $fo1 ="./output/cancermine_collated_and_ensg_symbol.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "role\tgene_entrez_id\tcancer_id\tcancer_normalized\tgene_hugo_id\tgene_normalized\tcitation_count\tensg\tsymbol";
print $O1 "$header\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^entrezgene/){
        my $entrezgene = $f[0];
        my $ensg = $f[1];
        $ensg =~s/c\("//g;
        $ensg =~s/"//g;
        $ensg =~s/,.*$//g;
        my $symbol =$f[2];
        my $v=  "$ensg\t$symbol";
        $hash1{$entrezgene}=$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^matching_id/){
        my $role = $f[1];
        my $cancer_id = $f[2];
        my $cancer_normalized =$f[3];
        my $gene_hugo_id = $f[4];
        my $gene_entrez_id = $f[5];
        my $gene_normalized = $f[6];
        my $citation_count = $f[-1];
        $role =~ s/Oncogene/GOF/g;
        $role =~ s/Tumor_Suppressor/LOF/g;
        my $output = "$role\t$gene_entrez_id\t$cancer_id\t$cancer_normalized\t$gene_hugo_id\t$gene_normalized\t$citation_count";
        if (exists $hash1{$gene_entrez_id}){
            my $v= $hash1{$gene_entrez_id};
            my $final_output=  "$output\t$v";
            print $O1 "$final_output\n";
        }
        else{
            print "$gene_entrez_id\n";
        }

    }
}