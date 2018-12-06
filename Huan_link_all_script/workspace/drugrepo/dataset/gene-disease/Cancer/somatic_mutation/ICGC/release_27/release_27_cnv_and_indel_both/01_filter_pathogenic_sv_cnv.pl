#对./hotspot/中的文件进行pathogenic过滤，过滤文件放在./pathogenic_hotspot/  ,并把tra和inv合在一起得./pathogenic_hotspot/all_tra_inv.txt，
#得CNV，dup，del合在一起得./pathogenic_hotspot/all_CNV_dup_del.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;



my $fo6 ="./pathogenic_hotspot/all_CNV_dup_del.txt";
open my $O6, '>', $fo6 or die "$0 : failed to open output file '$fo6' : $!\n";

my $fo7 ="./pathogenic_hotspot/all_tra_inv.txt";
open my $O7, '>', $fo7 or die "$0 : failed to open output file '$fo7' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
my $f1 ="./hotspot/del_svscore";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./pathogenic_hotspot/del_svscore_pathogenic_hotspot.txt";  
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $SVSCORETOP10 =$f[4];
    if(/^#CHROM/){
        print $O1 "$_\n";
        print $O6 "$_\tSVTYPE\tsource\n";  #输出到总文件
    }
    else{
        if($SVSCORETOP10 >15){
            print $O1 "$_\n";
            print $O6 "$_\tNA\tdel_svscore\n";  #输出到总文件,因为没有SVTYPE，所以用NA填充
        }
    }
}

my $f2 ="./hotspot/dup_svscore";
my $fo2 ="./pathogenic_hotspot/dup_svscore_pathogenic_hotspot.txt"; 
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    my $SVSCORETOP10 =$f[4];
    if(/^#CHROM/){
        print $O2 "$_\n";
    }
    else{
        if($SVSCORETOP10 >15){
            print $O2 "$_\n";
            print $O6 "$_\tNA\tdup_svscore\n";  #输出到总文件,因为没有SVTYPE，所以用NA填充
        }
    }
}


my $f3 ="./hotspot/inv_svscore";
my $fo3 ="./pathogenic_hotspot/inv_svscore_pathogenic_hotspot.txt"; 
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my $f5 ="./hotspot/cnv_svscore";
my $fo5 ="./pathogenic_hotspot/cnv_svscore_pathogenic_hotspot.txt"; 
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $O5, '>', $fo5 or die "$0 : failed to open output file '$fo5' : $!\n";

while(<$I5>)
{
    chomp;
    my @f= split /\t/;
    my $SVSCORETOP10 =$f[4];
    if(/^#CHROM/){
        print $O5 "$_\n";
        # print STDERR "$SVSCORETOP10\n";
    }
    else{
        if($SVSCORETOP10 >15){
            print $O5 "$_\n";
            print $O6 "$_\tcnv_svscore\n";  #输出到总文件
        }
    }
}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    my $SVSCORETOP10 =$f[7];
    if(/^#CHR1/){
        print $O3 "$_\n";
        print $O7 "$_\tsource\n";  #输出到总文件
    }
    else{
        if($SVSCORETOP10 >15){
            print $O3 "$_\n";
            print $O7 "$_\tinv_svscore\n";  #输出到总文件,因为没有SVTYPE，所以用NA填充
        }
    }
}

my $f4 ="./hotspot/tra_svscore";
my $fo4 ="./pathogenic_hotspot/tra_svscore_pathogenic_hotspot.txt"; 
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    my $SVSCORETOP10 =$f[7];
    if(/^#CHR1/){
        print $O4 "$_\n";
        # print STDERR "$SVSCORETOP10\n";
    }
    else{
        if($SVSCORETOP10 >15){
            print $O4 "$_\n";
            print $O7 "$_\ttra_svscore\n";  #输出到总文件,因为没有SVTYPE，所以用NA填充
        }
    }
}

