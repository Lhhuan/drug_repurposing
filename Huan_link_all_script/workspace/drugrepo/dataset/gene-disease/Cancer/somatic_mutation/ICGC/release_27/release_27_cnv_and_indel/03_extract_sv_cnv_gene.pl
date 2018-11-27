#将./pathogenic_hotspot/all_SV_and_CNV_pathogenic_hotspot_gene.bed中提取sv和cnv的基本信息及其对应的gene，把0 based转换为1 based,得./pathogenic_hotspot/03_all_SV_and_CNV_pathogenic_hotspot_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./pathogenic_hotspot/all_SV_and_CNV_pathogenic_hotspot_gene.bed";
my $fo1 ="./pathogenic_hotspot/03_all_SV_and_CNV_pathogenic_hotspot_gene.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "#CHROM\tBEGIN\tEND\tPROJECT\tSVSCORETOP10\tSVSCOREMAX\tSVSCORESUM\tSVSCOREMEAN\tSVTYPE\tsource\tID\tENSG";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#CHROM/){
        my $CHROM =$f[0];
        my $tran_BEGIN =$f[1];
        my $BEGIN = $tran_BEGIN +1; #0_baesd转换成1 based 将begin+1
        my $END =$f[2];
        my $PROJECT =$f[3];
        my $SVSCORETOP10 =$f[4];
        my $SVSCOREMAX =$f[5];
        my $SVSCORESUM =$f[6];
        my $SVSCOREMEAN =$f[7];
        my $SVTYPE =$f[8];
        my $source = $f[9];
        my $id =$f[10];   
        my $ensg = $f[14];
        my $out1 = join("\t",@f[2..10]);
        my $output = "$CHROM\t$BEGIN\t$out1\t$ensg";
        unless (exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}