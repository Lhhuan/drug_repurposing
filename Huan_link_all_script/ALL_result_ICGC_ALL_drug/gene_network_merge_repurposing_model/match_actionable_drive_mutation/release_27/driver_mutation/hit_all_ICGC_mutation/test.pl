#寻找driver mutation中的pathogenicity_mutation，寻找在./output/01_ICGC_mutation_id_HGVSg.txt中出现的"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/driver_mutation/all_driver_mutation/output/02_transvar_hgvsg.txt"
#得./output/04_actionable_mutaton_in_pathogenicity.txt ,得不在目标里的mutation文件./output/04_can_transform_actionable_mutaton_not_in_pathogenicity.txt 得所有的actionable mutation文件./output/04_all_actionable_mutation.txt，得可以转成hgvs的actionable_mutation文件./output/04_actionable_mutation_can_transform_hgvs.txt 
#得不可以转成hgvs的actionable_mutation文件./output/04_actionable_mutation_can_not_transform_hgvs.txt 

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "test.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^chr;start;stop;ref;alt/){
        my $variant_id = $f[0];
        my $disease = $f[1];
        my $hgvsg = $f[-2];
        $hgvsg =~s/chr//g;
        $hgvsg =~ s/^\.$/NA/g; #把只是.的替换为NA
        $hgvsg =~s/del.*ins/delins/g;
        print "$hgvsg\n";
    }
}

