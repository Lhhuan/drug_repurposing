#把 ../output/07_tra_in_huan.txt 和 ../output/06_filter_cnv_in_huan.txt merge到一起，得../output/08_merge_all_sv.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../output/07_tra_in_huan.txt";
my $f2 ="../output/06_filter_cnv_in_huan.txt";
my $fo1 ="../output/08_merge_all_sv.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
my $header = "sample_name\tSVSCORETOP10\tsource\tID\toncotree_ID\toncotree_ID_type";
print $O1 "$header\n";
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^sample_name/){
        my $sample_name =$f[0];
        my $SVSCORETOP10 =$f[8];
        my $source = $f[9];
        my $ID = $f[10];
        my $oncotree_ID = $f[11];
        my $oncotree_ID_type = $f[12];
        my $output = "$sample_name\t$SVSCORETOP10\t$source\t$ID\t$oncotree_ID\t$oncotree_ID_type";
        unless(exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^sample_name/){
        my $sample_name =$f[0];
        my $SVSCORETOP10 =$f[5];
        my $source = $f[10];
        my $ID = $f[11];
        my $oncotree_ID = $f[12];
        my $oncotree_ID_type = $f[13];
        my $output = "$sample_name\t$SVSCORETOP10\t$source\t$ID\t$oncotree_ID\t$oncotree_ID_type";
        unless(exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}

