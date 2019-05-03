#将10_split_add_hgvsg_symbol.txt和11_transform_add_ensg_entrezid.txt merge 到一起得12_add_mutation_ensg_entrezid_info.txt,得addid和project 的文件得12_add_project_mutation_id.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./10_split_add_hgvsg_symbol.txt";
my $f2 = "./11_transform_add_ensg_entrezid.txt";
my $fo1 = "./12_add_mutation_ensg_entrezid_info.txt";
my $fo2 = "./12_add_project_mutation_id.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Mutation_ID\tGene\tMap_to_gene_level\tentrezgene\n";
print $O2 "ID\tproject\n";
while(<$I1>)
{
    chomp;
    unless (/^Mutation_ID/){
        my @f = split/\t/;
        my $project = $f[4];
        my $gene =$f[5];
        my $mutation_ID = $f[6];
        if ($mutation_ID=~/\>/){
            push @{$hash1{$gene}},$mutation_ID;
            my $v = "$mutation_ID\t$project";
            unless (exists $hash2{$v}){
                $hash2{$v} =1;
                print $O2 "$v\n";
            }

        }
     }
}

while(<$I2>)
{
    chomp;
    unless (/^query/){
        my @f = split/\t/;
        my $gene = $f[0];
        my $ensg = $f[1];
        $ensg =~s/\\c//g;
        $ensg =~ s/\(//g;
        $ensg =~s/\"//g;
        $ensg =~s/,.*$//g;
        # print "$ensg\n";
        my $entrezgene =$f[2];
        if (exists $hash1{$gene}){
            my @ids = @{$hash1{$gene}};
            foreach my $id(@ids){
                my $output = "$id\t$ensg\tLevel1_1_protein_coding\t$entrezgene";
                unless(exists $hash3{$output}){
                    $hash3{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }

    }
}
