#对CosmicCompleteCNAunique.txt文件进行处理，得到GISTIC算法需要的输入，得文件GISTIC_seg_file.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./CosmicCompleteCNAunique.txt";
my $fo1 = "./GISTIC_seg_file.txt";
# my $fo2 = "./simple_somatic_mutation_largethan1_nm_vep_coding.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#print $O1 "Sample\tChromosome\tStart_Position\tEnd_Position\tNum_markers\tSeg_CN\n";
my %hash1;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^CNV_ID/){
        my $CNV_ID = $f[0];
        my $ID_SAMPLE = $f[1];
        my $SAMPLE_NAME = $f[2];
        my $TOTAL_CN = $f[3];
        my $MINOR_ALLELE = $f[4];
        my $MUT_TYPE = $f[5];
        my $Chromosome_G_Start_G_Stop = $f[6];
        my @f1 = split/\:/,$Chromosome_G_Start_G_Stop;
        my $Chromosome = $f1[0];
        $Chromosome =~s/X/23/g;
        $Chromosome =~s/Y/23/g;
        my @f2 = split/\../,$f1[1];
        my $start_pos = $f2[0];
        my $end_pos = $f2[1];
        #my $seg_cn = log2($TOTAL_CN)-1;
        unless($TOTAL_CN=~/^$/){
        my $cn = $TOTAL_CN+1;
        my $seg_cn = log($cn)/log(2) -1; #因为0不能取对数，所有加1
        $seg_cn=sprintf "%.6f",$seg_cn;
        my $num_markers = $CNV_ID;
        my $k = "$SAMPLE_NAME\t$Chromosome\t$start_pos\t$end_pos\t$num_markers\t$seg_cn";
        unless(exists $hash1{$k}){
            $hash1{$k}=1;
            print $O1 "$k\n";
        }
        }
     }
}

