#把./pathogenic_hotspot/all_SV_and_CNV_pathogenic_hotspot.txt转换成bed格式，并编号id，最终得文件./pathogenic_hotspot/all_SV_and_CNV_pathogenic_hotspot.bed
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./pathogenic_hotspot/all_SV_and_CNV_pathogenic_hotspot.txt";
my $fo1 ="./pathogenic_hotspot/all_SV_and_CNV_pathogenic_hotspot.bed";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    if(/^#CHROM/){
        print $O1 "$_\tID\n";
    }
    else{
        my $CHROM =$f[0];
        my $BEGIN =$f[1];
        my $tran_BEGIN = $BEGIN -1; #0_baesd将begin-1
        my $END =$f[2];
        my $PROJECT =$f[3];
        my $SVSCORETOP10 =$f[4];
        my $SVSCOREMAX =$f[5];
        my $SVSCORESUM =$f[6];
        my $SVSCOREMEAN =$f[7];
        my $SVTYPE =$f[8];
        my $source = $f[9];
        my $num = $.-1;#$.是行号
        my $id ="ID$num";   
        my $out1 = join("\t",@f[2..9]);
        my $output = "$CHROM\t$tran_BEGIN\t$out1\t$id";
        print $O1 "$output\n";
    }
}

