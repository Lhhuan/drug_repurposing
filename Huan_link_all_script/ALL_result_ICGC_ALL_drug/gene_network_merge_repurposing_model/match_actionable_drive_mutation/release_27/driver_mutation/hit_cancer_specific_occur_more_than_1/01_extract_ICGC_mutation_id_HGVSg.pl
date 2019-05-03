#将"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1_vep.vcf"
#中的mutation id和HVSGg提取出来，得./output/07_ICGC_mutation_id_HGVSg.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1_vep.vcf";
my $fo1 ="./output/01_ICGC_mutation_id_HGVSg.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
print  $O1 "Mutation_ID\tHGVSg\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^#/){
        my $Mutation_ID = $f[0];
        my $Extra = $f[-1];
        my @infos=split/\;/,$Extra;
        foreach my $info (@infos){
            if ($info =~/^HGVSg/){
                my @hg_infos= split/\=/,$info;
                my $HGVSg = $hg_infos[1];
                my $output = "$Mutation_ID\t$HGVSg";
                unless(exists $hash1{$output}){
                    $hash1{$output}=1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
