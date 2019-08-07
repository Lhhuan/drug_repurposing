#选出MELA-AU和SKCM-US的>=2的sv和cnv的信息，得../output/sv_cnv.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_SV_CNV/v4/output/all_pathogenicity_sv_snv.vcf";
my $fo1 = "../output/sv_cnv.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "position\tproject\tID\tsource\toccurance\n";

while(<$I1>)
{
    chomp;
    unless (/^POS/){
        my @f= split/\t/;
        my $POS =$f[0];
        my $project =$f[2];
        my $ID =$f[3];
        my $Source =$f[4];
        my $occurance =$f[5];
        if ($project =~/MELA-AU|SKCM-US/){
           print $O1 "$POS\t$project\t$ID\t$Source\t$occurance\n";
        }
    }
}



