#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use Compress::Zlib; #读压缩文件的包


my $f1 ="../summary_outside_cancer.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";

my $f2 ="./huan_ukbb_biobank/variants.tsv";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my %hash1;
while(<$I2>) 
{
    chomp;
    my @f= split /\t/;
    unless(/^variant/){
        my $rsid = $f[1];
        my $alt_af = $f[3];
        $hash1{$rsid}=$alt_af;
        #print STDERR "$rsid\t$alt_af\n";
    }
    
}


my @group_file;
while(<$I1>) 
{
    chomp;
    my @f= split /\t/;
    my $Folder_name_local = $f[10];
    my $File_ID_local = $f[12];    
    if($Folder_name_local=~/UKBB_biobank/){
        push @group_file,$File_ID_local;
    }
}

foreach my $file(@group_file){
    if ($file =~/assoc/){ #只针对assoc的文件
        my $prefix = $file;
        $prefix =~s/.tsv.gz//g;
        my $output = "${prefix}.normalized.txt";
        my $dir = "huan_ukbb_biobank";
        my $f2 = "$dir/$file";


        #my $file = "logfile.gz"; #读取压缩文件
        my $gz = gzopen($f2, "rb") #输入文件
        or die "Cannot open $f2: $gzerrno\n" ;


        #open my $DATE1, 'zcat $f2|' or die "zcat $f2 $0: $!\n"; 
        my $fo1 ="./huan_ukbb_biobank/$output"; #输出文件
        #my $fo1 ="./$output";
        open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
        my $header = "chromosome\tposition\trsid\treference_allele\tallele_frequency_reference_allele\talternative_allele\tallele_frequency_alternative_allele\tminor_allele\tmaf\tbaseline_allele\teffect_allele\teffect_size\(beta\)";
        $header = "$header\tstandard_error\(SE\)\todds_ratio\(OR\)\tOR_95I\tZscore\tTstat\tChisq\tOR_P\tBeta_P\tT_P\tsample_size\tAC\tytx";
        select $O1;
        print "$header\n";
 
        while ($gz->gzreadline($_) > 0)
        {
            chomp;
            my @f= split /\t/;
            unless(/^variant/){
                my $chr_info = $f[0];
                my @info = split/\:/,$chr_info;
                my $chr = $info[0];
                my $pos = $info[1];
                my $ref = $info[2];
                my $alt = $info[3];
                my $rsid = $f[1];
                my $sample = $f[2];
                my $AC = $f[3];
                my $ytx = $f[4];
                my $beta = $f[5];
                my $se = $f[6];
                my $tstat = $f[7];
                my $Beta_P = $f[8];
                my $effect_allele = $alt;
                my $baseline_allele= $ref;
                my $Zscore = $tstat; #zscore和tstat在sample size很大的时候是近似相等的;ukbb的samplesize足够大
                if (exists $hash1{$rsid}){
                    my $alt_af = $hash1{$rsid};
                    print $O1 "$chr\t$pos\t$rsid\t$ref\tNA\t$alt\t$alt_af\tNA\tNA\t$baseline_allele\t$effect_allele\t$beta\t$se\tNA\tNA\t$Zscore\t$tstat\tNA\tNA\t$Beta_P\tNA\t$sample\t$AC\t$ytx\n";
                }
                else{
                    print $O1 "$chr\t$pos\t$rsid\t$ref\tNA\t$alt\tNA\tNA\tNA\t$baseline_allele\t$effect_allele\t$beta\t$se\tNA\tNA\t$Zscore\t$tstat\tNA\tNA\t$Beta_P\tNA\t$sample\t$AC\t$ytx\n";
                }
            }
        }

    }
}





