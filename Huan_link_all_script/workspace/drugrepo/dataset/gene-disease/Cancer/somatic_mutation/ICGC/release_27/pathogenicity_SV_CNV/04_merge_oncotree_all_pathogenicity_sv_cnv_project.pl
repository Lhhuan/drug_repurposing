#把./output/merge_all_pathogenicity_sv_cnv_project.txt 和"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt"
#得./output/merge_oncotree_all_pathogenicity_sv_cnv_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt";
my $f2 = "./v4/output/all_pathogenicity_sv_snv.vcf";
my $fo1 = "./v4/output/all_pathogenicity_sv_snv_oncotree.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;

# print $O1 "mutation\tproject\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tClass\n";
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
    if (/^POS/){
        print $O1 "$_\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\n";
    }
    else{
        my @f =split/\t/;
        my $POS = $f[0];
        my $Score = $f[1];
        my $Project = $f[2];
        my $ID = $f[3];
        my $Source = $f[4];
        my $occurance = $f[5];
        my @pros = split /\,/,$Project;
        foreach my $pro(@pros){
            if (exists $hash1{$pro}){
                my $oncotree = $hash1{$pro};
                my $output= "$POS\t$Score\t$pro\t$ID\t$Source\t$occurance\t$oncotree";
                unless(exists $hash2{$output}){
                    $hash2{$output}=1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}

