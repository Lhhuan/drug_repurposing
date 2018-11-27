#用021_drug_target.txt和0211_gold_standard_overlap_rwr.txt找出的rwr 最短路径的组合,得文件027_gold_standard_shortest_pair.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./021_drug_target.txt";#输入的是drug target 以及repo和其gene（相当于rwr的start 和目标end）
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./0211_gold_standard_overlap_rwr.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./027_gold_standard_shortest_pair.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "drug\tstart\tend\n";
my %hash1;
my %hash2;
my %hash3;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug_name/){
        my $drugname = $f[0];
        my $drug_target_id = $f[1];
        push @{$hash1{$drugname}},$drug_target_id;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drugname = $f[1];
        my $rwr_end = $f[3];
        push @{$hash2{$drugname}},$rwr_end;
    }
}


foreach my $drug (sort keys %hash1){
    if(exists $hash2{$drug}){
        my @drug_targets = @{$hash1{$drug}};
        my @ends = @{$hash2{$drug}};
        foreach my $drug_target(@drug_targets){
            foreach my $end(@ends){
                my $output = "$drug\t$drug_target\t$end";
                unless(exists $hash3{$output}){
                    $hash3{$output} =1 ;
                    print $O1 "$output\n";
                }
            }
        }
    }
    else{
        print STDERR "$drug\n";
    }
}