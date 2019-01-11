#检查所有project (./data/download_TCGA_from_UCSC_xena/${project}/)下CNV和SNV的header是否相同，结果存放在./output/01_cnv_header.txt 和./output/01_snv_header.txt，结果显示，project下CNV和SNV的header是相同的
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./data/Project.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 = "./output/01_snv_header.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/01_cnv_header.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);


while(<$I1>)
{
    chomp;
    unless(/^project/){
        my @f= split/\t/;
        my $project = $f[0];
        my $cmd1 = "zless ./data/download_TCGA_from_UCSC_xena/${project}/snv/*.gz | head -1";
        my @temp_result = readpipe($cmd1); #捕获system 的返回值
        print $O1 @temp_result;
        #-----------------------------------------------------------------------------------
        my $cmd2 = "zless ./data/download_TCGA_from_UCSC_xena/${project}/cnv/*.gz | head -1";
        my @temp_result2 = readpipe($cmd2); #捕获system 的返回值
        print $O2 @temp_result2;
    }
}

close($O1);