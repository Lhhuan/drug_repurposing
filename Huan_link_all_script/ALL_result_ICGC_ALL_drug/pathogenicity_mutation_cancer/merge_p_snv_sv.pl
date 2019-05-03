#将./output/Pathogenic_snv_indel_project.txt 和"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_SV_CNV/v4/output/all_sv_snv.vcf"
#merge到一起，得各种类型数据统计数据./output/sv_snv_number.txt #得各project中，sv和cnv数目统计数据得./output/project_mutation_type_number.txt,得总表./output/merge_P_snv_sv.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_SV_CNV/v4/output/all_sv_snv.vcf";
my $f2 = "./output/Pathogenic_snv_indel_project.txt";
my $fo1 = "./output/merge_P_snv_sv.txt";
my $fo2 = "./output/sv_snv_number.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2);

print $O1 "POS\tScore\tProject\tID\tSource\toccurance\n";
print $O2 "Source\tnumber\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless  (/^POS/){
        my $pos = $f[0];
        my $score = $f[1];
        my $project = $f[2];
        my $id = $f[3];
        my $source = $f[4];
        my @projects = split/,/,$project;
        my $occur = @projects;
        foreach my $pro(@projects){
            my $output = "$pos\t$score\t$pro\t$id\t$source\t$occur";
            unless(exists $hash1{$output}){
                $hash1{$output} =1;
                print $O1 "$output\n";
            }
        }
        push @{$hash2{$source}},$id;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless  (/^CADD_MEANPHRED/){
        my $pos = "NA";
        my $score = $f[0];
        my $project = $f[2];
        my $id = $f[1];
        my $source = "SNV/Indel";
        my $occur =$f[-1];
        my $output = "$pos\t$score\t$project\t$id\t$source\t$occur";
        unless(exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
        push @{$hash2{$source}},$id;
    }
}

foreach my $source (sort keys %hash2){
    my @vs = @{$hash2{$source}};
    my %hash3;
    @vs = grep { ++$hash3{$_} < 2 } @vs ; ##数组内去重
    my $number = @vs;
    print $O2 "$source\t$number\n";
}