#把10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.txt和ICGC_occurthan1_snv_indel_project_oncotree.txt merge在一起，得11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt
#顺便把ICGC_occurthan1_snv_indel_project_oncotree.txt normalized 把引号什么的都去掉。得ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.txt";
my $f2 = "./ICGC_occurthan1_snv_indel_project_oncotree.txt";
my $fo1 = "./11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt";
my $fo2 = "./ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Mutation_ID\tENSG\tMap_to_gene_level\tentrezgene\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\toncotree_term\toncotree_ID\n";
print $O2 "project\tcancer_ID\tproject_full_name\toncotree_term\toncotree_ID\n";
while(<$I1>)
{
    chomp;
    unless (/^Mutation_ID/){
        my @f = split/\t/;
        my $mutation_ID = $f[0];
        my $ensg = $f[1];
        my $Map_to_gene_level =$f[2];
        my $entrezgene =$f[3];
        my $project =$f[4];
        my $cancer_specific_affected_donors = $f[5];
        my $output = "$mutation_ID\t$ensg\t$Map_to_gene_level\t$entrezgene\t$project\t$cancer_specific_affected_donors";
        push @{$hash1{$project}},$output;
     }
}

while(<$I2>)
{
    chomp;
    unless (/^term/){
        my $line = $_;
        $line =~s/"//g;
        my @f = split/\t/,$line;
        my $project =$f[1];
        my $cancer_ID = $f[2];
        my $project_full_name = $f[3];
        my $oncotree_term = $f[4];
        my $oncotree_ID = $f[5];
        my $info = "$cancer_ID\t$project_full_name\t$oncotree_term\t$oncotree_ID";
        $hash2{$project}=$info;

        print $O2 "$project\t$info\n";
     }
}

foreach my $ID(sort keys %hash1){
    if(exists $hash2{$ID}){
        my @infos =@{$hash1{$ID}};
        my $project_info = $hash2{$ID};
        foreach my $info(@infos){
            my $output = "$info\t$project_info";
            unless(exists $hash3{$output}){
                 $hash3{$output} = 1;
                print $O1 "$output\n";
            }
        }
    }
    else{
        print STDERR "$ID\n";
    }
}


