#筛选出ID_project.txt中是致病性的mutation及其对应的project. 得文件pathogenicity_id_project.txt,并为project有多个mutation 计数得project_pathogenicity_mutation_number.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/cadd_score/SNV_Indel_cadd_score.vcf";
my $f2 = "./ID_project.txt";
my $fo1 = "./pathogenicity_id_project.txt";
my $fo2 = "./project_pathogenicity_mutation_number.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

print $O2 "project\tmutation_number\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#CHROM/){
        my @f =split/\t/;
        my $mutation_id = $f[2];
        my $MEANPHRED = $f[9];
        if($MEANPHRED>=15){
            $hash1{$mutation_id}=$MEANPHRED;
        }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    if (/^ID/){
        print $O1 "$_\tCADD_MEANPHRED\n";
    }
    else{
        my $mutation_id = $f[0];
        my $project = $f[1];
        my $occurance = $f[2];
        if (exists $hash1{$mutation_id}){
            my $MEANPHRED = $hash1{$mutation_id};
            my $output = "$_\t$MEANPHRED";
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
    }
}
close($O1);

my $f3 = "./pathogenicity_id_project.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless (/^ID/){
        my $mutation_id = $f[0];
        my $project = $f[1];
        my $occurance = $f[2];
        my $cadd = $f[3];
        push @{$hash3{$project}},$mutation_id
    }
}


foreach my $project (sort keys %hash3){
    my @mutation_ids  = @{$hash3{$project}};
    my $m_number = @mutation_ids;
    my $output = "$project\t$m_number";
    print $O2 "$output\n";
}

