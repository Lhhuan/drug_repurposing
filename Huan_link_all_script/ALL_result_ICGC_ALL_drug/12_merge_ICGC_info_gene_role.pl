##把./output/11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt和./output/normal_four_source_gene_role.txt merge 在一起，得文件./output/12_merge_ICGC_info_gene_role.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt";
my $f2 = "./output/normal_four_source_gene_role.txt";
my $fo1 = "./output/12_merge_ICGC_info_gene_role.txt";
my $fo2 = "./output/12_co_ICGC_info_gene_role.txt"; #两个数据库重合的基因。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Mutation_ID\tENSG\tMap_to_gene_level\tentrezgene\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer\n";
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
        #my $output = "$mutation_ID\t$ensg\t$Map_to_gene_level\t$entrezgene\t$project";
        push @{$hash1{$ensg}},$_;
     }
}

while(<$I2>)
{
    chomp;
    unless (/^symbol|Gene/){
        my @f= split/\t/;
        my $role_in_cancer = $f[3];
        my $ENSG_ID = $f[-1];
        $hash2{$ENSG_ID}=$role_in_cancer;
     }
}

foreach my $ID(sort keys %hash1){
    if(exists $hash2{$ID}){
        print $O2 "$ID\n";
        my @infos =@{$hash1{$ID}};
        my $role_in_cancer = $hash2{$ID};
        foreach my $info(@infos){
            my $output = "$info\t$role_in_cancer";
            unless(exists $hash3{$output}){
                 $hash3{$output} = 1;
                print $O1 "$output\n";
            }
        }
    }
    else{
        my @infos =@{$hash1{$ID}};
        foreach my $info(@infos){
            my $output = "$info\tNA";
            unless(exists $hash3{$output}){
                 $hash3{$output} = 1;
                print $O1 "$output\n";
            }
        }
    }
}


