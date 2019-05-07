# 用../cadd_score/SNV_Indel_cadd_score_simple.txt "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/pathogenicity_mutation_cancer/output/average_Pathogenic_occurance.txt" 筛选致病性的mutation
#得文件pathogenicity_mutation_id.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt";
my $f2 = "../cadd_score/SNV_Indel_cadd_score_simple.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);


while(<$I1>)
{
    chomp;
    unless (/^ICGC_Mutation_ID/){
        $hash1{$_}=1;
    }
}

while(<$I2>)
{
    chomp;
    unless (/^ID/){
        my @f= split/\t/;
        my $ID = $f[0];
        my $PHRED = $f[1];
        $hash2{$ID}=1;
    }
}

foreach my $id (sort keys %hash1){
    unless (exists $hash2{$id}){
        print "$id\n";
    }
}