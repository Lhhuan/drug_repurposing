# 将./output/out_icgc_add_cgi_info.txt和./output/out_icgc_add_cgi_vep.vcf merge到一起，得./output/01_merge_out_icgc_info_and_position.txt
#得对应的unique cancer 文件./output/01_unique_cgi_out_icgc_cancer.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/out_icgc_add_cgi_vep.vcf";
my $f2 = "./output/out_icgc_add_cgi_info.txt";
my $fo1 = "./output/01_merge_out_icgc_info_and_position.txt";
my $fo2 = "./output/01_unique_cgi_out_icgc_cancer.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
# print $O2 "Mutation_ID\thgvsg\n";


while(<$I1>)
{
    chomp;
    unless (/^#/){
        my @f =split/\t/;
        my $CHROM =$f[0];
        my $POS = $f[1];
        my $ID =$f[2];
        my $REF = $f[3]; 
        my $ALT = $f[4];
        my $v= "$CHROM\t$POS\t$REF\t$ALT";
        $hash1{$ID}=$v;
    }
}

while(<$I2>)
{
    chomp;
    if (/^gene/){
        print $O1 "CHROM\tPOS\tREF\tALT\t$_\n";
    }
    else{
        my @f = split/\t/;
        my $gdna = $f[1];
        my $cancer = $f[6];
        $gdna =~s/chr//g;
        unless($gdna =~ /__/){
            # print  "$gdna\n";
            if (exists $hash1{$gdna}){
                my $v = $hash1{$gdna};
                print $O1 "$v\t$_\n";
                unless(exists $hash2{$cancer}){
                    $hash2{$cancer} =1;
                    print $O2 "$cancer\n";
                }
            }
            else{
                print "$gdna\n";
            }
        }
        # if($gdna =~ /__/){
        #     print  "$gdna\n";
        # }
    }
}