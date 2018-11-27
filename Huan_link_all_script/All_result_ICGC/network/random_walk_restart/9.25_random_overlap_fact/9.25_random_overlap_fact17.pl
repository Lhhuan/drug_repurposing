#利用记录drug target 数目的文件9.21_drug_target_num.txt，把./huan_data_rwr/random_select/rwr_result_top_0.044/${num}/result${i}.txt 和08_drug_start_comma_end.txt中的end 取交集。得文件9.25_random_overlap_fact.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./input/9.21_drug_target_num17.txt";#输入的是drug target 数目
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="../08_drug_start_comma_end.txt";#输入的是drug 及其rwr top0.044的end
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/9.25_random_overlap_fact17.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "drug\trandom_overlap_fact_end\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    unless(/^drug/){
        my @f=split/\t/;
        my $drug = $f[0];
        my $target_num = $f[1];
        push @{$hash1{$target_num}},$drug;
    }
}

while(<$I2>)   #这步把在start中出现的end 除去（因为end ==start 是gene based 的repurposing,不属于network based repurposing）
{
    chomp;
    unless(/^drug/){
        my @f=split/\t/;
        my $drug = $f[0];
        my $start = $f[1];
        my $end = $f[2];
        my @f1 = split /\t/,$start;
        my %hash7;
        foreach my $start1(@f1){
            $hash7{$start1}=1;
        }
        unless(exists $hash7{$end}){
            push @{$hash2{$drug}},$end;
        }
    }
}

foreach my $num(sort keys %hash1){
    my @drugs = @{$hash1{$num}};
    my %hash5;
    @drugs = grep { ++$hash5{$_} < 2 } @drugs;
    foreach my $drug(@drugs){
        if (exists $hash2{$drug}){
            my @ends = @{$hash2{$drug}};
            my %hash6;
            @ends = grep { ++$hash6{$_} < 2 } @ends;
            for(my $i=1; $i<1001;$i++){# 把./huan_data_rwr/random_select/rwr_result_top_0.044/${num}/result${i}.txt 和08_drug_start_comma_end.txt中的end 取交集
                my $f3 ="../huan_data_rwr/random_select/rwr_result_top_0.044/${num}/result${i}.txt";
                open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
                while(<$I3>)
                {
                    chomp;
                    my @f = split/\t/;
                    my $end_random_select = $f[0];
                    foreach my $end(@ends){
                        if ($end==$end_random_select){
                            my $out = "$drug\t$end";
                            print $O1 "$out\n";
                        }
                    }

                }
            }
        }
    }
}


