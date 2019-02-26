#把./output/merge_all_pathogenicity_sv_cnv_project.txt 和"/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"
#得./output/merge_oncotree_all_pathogenicity_sv_cnv_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt";
my $f2 = "./output/merge_all_pathogenicity_sv_cnv_project.txt";
my $fo1 = "./output/merge_oncotree_all_pathogenicity_sv_cnv_project.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;

print $O1 "mutation\tproject\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tClass\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^project/){
        my @f =split/\t/;
        my $project = $f[0];
        my $oncotree = join("\t",@f[-4..-1]);
        $hash1{$project}=$oncotree;
    }
}
my %hash2;
while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^mutation/){
        my @f =split/\t/;
        my $mutation_id = $f[0];
        my $project = $f[1];
        my $type = $f[2];
        if (exists $hash1{$project}){
            my $oncotree = $hash1{$project};
            my $output = "$mutation_id\t$project\t$oncotree\t$type";
            unless(exists $hash2{$output}){
                $hash2{$output}=1;
                print $O1 "$output\n";
            }
        }
    }
}

