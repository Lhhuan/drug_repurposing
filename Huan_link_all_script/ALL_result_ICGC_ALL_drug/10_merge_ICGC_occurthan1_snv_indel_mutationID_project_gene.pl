#把./output/ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt和./output/ICGC_occurthan1_snv_indel_mutationID_project.txt merge在一起
#得文件./output/10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt";
my $f2 = "./output/ICGC_occurthan1_snv_indel_mutationID_project.txt";
my $fo1 = "./output/10_merge_ICGC_occurthan1_snv_indel_mutationID_project_gene.txt";
my $fo2 = "./output/10_cancer_specific_affected_donor_smallthan1.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Mutation_ID\tENSG_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_specific_affected_donors\n";
while(<$I1>)
{
    chomp;
    unless (/^Mutation_ID/){
        my @f = split/\t/;
        my $mutation_ID = $f[0];
        my $ensg = $f[1];
        my $Map_to_gene_level =$f[2];
        my $entrezgene =$f[3];
        my $output = "$mutation_ID\t$ensg\t$Map_to_gene_level\t$entrezgene";
        push @{$hash1{$mutation_ID}},$output;
     }
}

while(<$I2>)
{
    chomp;
    unless (/^ID/){
        my @f = split/\t/;
        my $mutation_ID = $f[0];
        # print STDERR "$mutation_ID\n";
        my $project =$f[1];
        my $cancer_specific_affected_donors = $f[2];
        my $v = "$project\t$cancer_specific_affected_donors";
        push@{$hash2{$mutation_ID}},$v;
     }
}

foreach my $mutation_ID(sort keys %hash1){
    if(exists $hash2{$mutation_ID}){
        my @infos =@{$hash1{$mutation_ID}};
        my @projects = @{$hash2{$mutation_ID}};
        foreach my $info(@infos){
            foreach my $project (@projects){
                my $output = "$info\t$project";
                unless(exists $hash3{$output}){
                    $hash3{$output} = 1;
                    print $O1 "$output\n";
                }
            }
        }
    }
    else{
        print $O2 "$mutation_ID\n";
    }
}


