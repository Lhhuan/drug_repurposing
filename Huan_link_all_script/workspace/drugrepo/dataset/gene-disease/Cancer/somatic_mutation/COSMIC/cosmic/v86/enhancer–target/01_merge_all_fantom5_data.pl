# 把所有的数据merge到一个文件，并在后面加上来源。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./famtom5_info.txt";
my $fo1 = "./01_merge_all_fantom5_data.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "region\tgene\tscore\tsource\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^ID/){
         my $ID = $f[0];
         my $f2 =  "./fantom5_elasticnet/fantom5_elasticnet.${ID}.csv";
        #  print "$f2\n";
         open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
         while(<$I2>){
             chomp;
             my @f1 = split/\,/;
             my $region = $f1[0];
             my $gene = $f1[1];
             my $score = $f1[2];
             print $O1 "$region\t$gene\t$score\tfantom5_elasticnet_${ID}\n";

         }
         close $I2 or warn "$0 : failed to close output file '$f2' : $!\n";
        my $f3 ="./fantom5_lasso/fantom5_lasso.${ID}.csv";
        open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
         while(<$I3>){
             chomp;
             my @f1 = split/\,/;
             my $region = $f1[0];
             my $gene = $f1[1];
             my $score = $f1[2];
             print $O1 "$region\t$gene\t$score\tfantom5_lasso_${ID}\n";
         }
         close $I3 or warn "$0 : failed to close output file '$f3' : $!\n";
    }
}
close $I1 or warn "$0 : failed to close output file '$f1' : $!\n";

my $f4 = "./ENCODE_Roadmap_info.txt";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    unless(/^ID/){
         my $ID = $f[0];
         my $f5 =  "./encoderoadmap_elasticnet/encoderoadmap_elasticnet.${ID}.csv";
         open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
         while(<$I5>){
             chomp;
             my @f1 = split/\,/;
             my $region = $f1[0];
             my $gene = $f1[1];
             my $score = $f1[2];
             print $O1 "$region\t$gene\t$score\tencoderoadmap_elasticnet_${ID}\n";
         }
         close $I5 or warn "$0 : failed to close output file '$f5' : $!\n";

         my $f6 =  "./encoderoadmap_lasso/encoderoadmap_lasso.${ID}.csv";
         open my $I6, '<', $f6 or die "$0 : failed to open input file '$f6' : $!\n";
         while(<$I6>){
             chomp;
             my @f1 = split/\,/;
             my $region = $f1[0];
             my $gene = $f1[1];
             my $score = $f1[2];
             print $O1 "$region\t$gene\t$score\tencoderoadmap_lasso_${ID}\n";
         }
         close $I6 or warn "$0 : failed to close output file '$f6' : $!\n";
    }
}
close $I4 or warn "$0 : failed to close output file '$f4' : $!\n";