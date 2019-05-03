#用./output/before_add_actionable_driver_Pathogenic_snv_indel_project.txt 计算Pathogenic mutation 平均突变频率，得文件./output/average_Pathogenic_occurance.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;

my $f1 = "./output/before_add_actionable_driver_Pathogenic_snv_indel_project.txt";
my $fo1 = "./output/average_Pathogenic_occurance.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2);

my @scores;
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless  (/^CADD_MEANPHRED/){
        my $score = $f[-1];
        push @scores, $score;
    }
}

my $sum = sum @scores;
my $number = @scores;
print "$number\n";
my $average_score = $sum/$number;
print $O1 "$average_score\n";