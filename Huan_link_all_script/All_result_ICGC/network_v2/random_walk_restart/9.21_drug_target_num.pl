#把08_drug_start_comma.txt中每个文件对应的start(target)的个数统计出来，得9.21_drug_target_num.txt 同时得9.21_drug_num.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;

my $f1 ="./08_drug_start_comma.txt";#输入的是drug target
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./9.21_drug_target_num.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./9.21_drug_num.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

print $O1 "drug\tnum\n";

my %hash1;
my %hash2;

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drugname = $f[0];
        my $drug_target_id = $f[1];
        my @targets = split/\,/,$drug_target_id;
        my $num = @targets;
        my$output1 = "$drugname\t$num";
        unless($hash1{$output1}){
            $hash1{$output1} =1 ;
            print $O1 "$output1\n";
        }
        unless($hash2{$num}){
            $hash2{$num}=1;
            print $O2 "$num\n";
        }

    }
}


