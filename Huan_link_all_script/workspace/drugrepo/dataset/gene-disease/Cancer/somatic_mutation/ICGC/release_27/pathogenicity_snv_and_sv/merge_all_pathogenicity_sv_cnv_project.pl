#把../release_27_cnv_and_indel_both/pathogenic_hotspot/cnv_svscore_pathogenic_hotspot_project_split.txt, 
#../release_27_cnv_and_indel_both/pathogenic_hotspot/inv_svscore_pathogenic_hotspot_project_split.txt,
#../release_27_cnv_and_indel_both/pathogenic_hotspot/tra_svscore_pathogenic_hotspot_project_split.txt,
#../release_27_cnv_and_indel_both/pathogenic_hotspot/del_svscore_pathogenic_hotspot_project_split.txt,
#../release_27_cnv_and_indel_both/pathogenic_hotspot/dup_svscore_pathogenic_hotspot_project_split.txt,
#../release_27_snv_indel/data_statistics/pathogenicity_id_project.txt merge成一个文件。得./output/merge_all_pathogenicity_sv_cnv_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../release_27_cnv_and_indel_both/pathogenic_hotspot/cnv_svscore_pathogenic_hotspot_project_split.txt";
my $f2 = "../release_27_cnv_and_indel_both/pathogenic_hotspot/inv_svscore_pathogenic_hotspot_project_split.txt";
my $f3 = "../release_27_cnv_and_indel_both/pathogenic_hotspot/tra_svscore_pathogenic_hotspot_project_split.txt";
my $f4 = "../release_27_cnv_and_indel_both/pathogenic_hotspot/del_svscore_pathogenic_hotspot_project_split.txt";
my $f5 = "../release_27_cnv_and_indel_both/pathogenic_hotspot/dup_svscore_pathogenic_hotspot_project_split.txt";
my $f6 = "../release_27_snv_indel/data_statistics/pathogenicity_id_project.txt";
my $fo1 = "./output/merge_all_pathogenicity_sv_cnv_project.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $I6, '<', $f6 or die "$0 : failed to open input file '$f6' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;

print $O1 "mutation\tproject\tClass\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#|hotspot/){
        my @f =split/\t/;
        my $mutation_id = $f[0];
        my $project = $f[1];
        my $output = "$mutation_id\t$project\tCNV";
        unless(exists $hash1{$output} ){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#|hotspot/){
        my @f =split/\t/;
        my $mutation_id = $f[0];
        my $project = $f[1];
        my $output = "$mutation_id\t$project\tInversion";
        unless(exists $hash1{$output} ){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#|hotspot/){
        my @f =split/\t/;
        my $mutation_id = $f[0];
        my $project = $f[1];
        my $output = "$mutation_id\t$project\tTranslocation";
        unless(exists $hash1{$output} ){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}

while(<$I4>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#|hotspot/){
        my @f =split/\t/;
        my $mutation_id = $f[0];
        my $project = $f[1];
        my $output = "$mutation_id\t$project\tDeletion";
        unless(exists $hash1{$output} ){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}

while(<$I5>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#|hotspot/){
        my @f =split/\t/;
        my $mutation_id = $f[0];
        my $project = $f[1];
        my $output = "$mutation_id\t$project\tDuplication";
        unless(exists $hash1{$output} ){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}

while(<$I6>)
{
    chomp;
    my @f= split/\t/;
    unless (/^ID/){
        my @f =split/\t/;
        my $mutation_id = $f[0];
        my $project = $f[1];
        my $output = "$mutation_id\t$project\tSNV/Indel";
        unless(exists $hash1{$output} ){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}
