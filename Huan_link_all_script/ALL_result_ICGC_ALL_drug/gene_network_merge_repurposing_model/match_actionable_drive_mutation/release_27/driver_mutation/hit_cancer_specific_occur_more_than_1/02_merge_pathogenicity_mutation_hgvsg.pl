# 把"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_mutationID_project.txt"
#和 ./output/01_ICGC_mutation_id_HGVSg.txt merge 到一起，得./output/02_pathogenicity_mutation_hgvsg.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_mutationID_project.txt";
my $f2 ="./output/01_ICGC_mutation_id_HGVSg.txt";
my $fo1 ="./output/02_pathogenicity_mutation_hgvsg.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Mutation_ID\tHGVSg\n";


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^ID/){
        my $mutation_id = $f[0];
        $hash1{$mutation_id}=1;
        # print "$mutation_id\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^Mutation_ID/){
        my $Mutation_ID = $f[0];
        my $HGVSg = $f[1];
        if (exists $hash1{$Mutation_ID}){
            print $O1 "$Mutation_ID\t$HGVSg\n";
        }
    }
}

