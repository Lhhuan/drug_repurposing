#把./pathogenic_hotspot/all_CNV_dup_del.txt转换成bed格式，并编号id，最终得文件./pathogenic_hotspot/all_CNV_dup_del.bed
#把./pathogenic_hotspot/all_tra_inv.txt中的两个hotspot 转换成bed格式，最终得文件"./pathogenic_hotspot/all_tra_inv.bed"; 
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./pathogenic_hotspot/all_CNV_dup_del.txt";
my $fo1 ="./pathogenic_hotspot/all_CNV_dup_del.bed";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#CHROM/){
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

my $f2 ="./pathogenic_hotspot/all_tra_inv.txt";
my $fo2 ="./pathogenic_hotspot/all_tra_inv.bed";  
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^#CHROM/){
        print $O2 "$_\tID\n";
    }
    else{
        my $CHROM1 =$f[0];
        my $BEGIN1 =$f[1];
        my $tran_BEGIN1 = $BEGIN1 -1; #0_baesd将begin-1
        my $END1 =$f[2];
        my $CHROM2 = $f[3];
        my $BEGIN2 =$f[4];
        my $tran_BEGIN2 = $BEGIN2 -1;
        my $END2 =$f[5];
        my $PROJECT =$f[6];
        my $SVSCORETOP10 =$f[7];
        my $SVSCOREMAX =$f[8];
        my $SVSCORESUM =$f[9];
        my $SVSCOREMEAN =$f[10];
        my $source = $f[11];
        my $num = "$CHROM1\_$BEGIN1\_$END1\_$CHROM2\_$BEGIN2\_$END2";
        my $id ="ID$num";   
        my $out1 = join("\t",@f[5..11]);
        my $output = "$CHROM1\t$tran_BEGIN1\t$END1\n$CHROM2\t$tran_BEGIN2\t$END2";
        print $O2 "$output\n";
    }
}
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";
system "cat ./pathogenic_hotspot/all_tra_inv.bed | sort -u >./pathogenic_hotspot/all_unique_tra_inv.bed";
