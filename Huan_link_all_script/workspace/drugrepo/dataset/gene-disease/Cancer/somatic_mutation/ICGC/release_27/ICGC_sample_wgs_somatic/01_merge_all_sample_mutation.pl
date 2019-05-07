#将./icgc_sample_data下的所有文件夹下的文件合在一起，得./output/01_all_sample_mutation.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;


my $fo1 ="./output/01_all_sample_mutation.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;
print $O1 "chr\tpos\tref\talt\tfile_id\n";

my $dir="./icgc_sample_data";
my @dirs =glob "$dir/*"; #捕获dir下的所有文件
foreach my $di (@dirs){ 
    my $bn = basename($di);#取$di的name
    my @fis = glob "$di/*";  #捕获$di的所有文件
    my $fi = $fis[0];
    open( my $I ,"gzip -dc $fi|") or die ("can not open\n"); #读压缩文件
    while(<$I>){
        chomp;
        unless(/^#/){
            my @f= split/\s+/;
            my $chr =$f[0];
            my $pos = $f[1];
            my $ref= $f[3];
            my $alt = $f[4];
            my $output = "$chr\t$pos\t$ref\t$alt\t$bn";
            # unless(exists $hash1{$output}){
                # $hash1{$output} =1;
                print $O1 "$output\n";
            # }
        }
    }
}

system "cat ./output/01_all_sample_mutation.txt |sort -u >./output/01_unique_all_sample_mutation.txt"