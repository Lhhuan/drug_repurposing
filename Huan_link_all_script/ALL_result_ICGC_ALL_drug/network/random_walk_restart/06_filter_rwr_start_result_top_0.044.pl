#./output/huan_data_rwr/rwr_result_top_0.044/${drug}.txt 中出现的./output/huan_data_rwr/start/${drug}.txt 去掉，得./output/huan_data_rwr/rwr_result_top_0.044_no_start/${drug}.txt 
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/03_huan_drug_target_num.txt";#输入的是drug target
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my %hash1;

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drugname = $f[0];
        $hash1{$drugname}=1;
    }
}

foreach my $drug (sort keys %hash1){

    my $f2 ="./output/huan_data_rwr/start/${drug}.txt";
    open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
    my $f3 ="./output/huan_data_rwr/rwr_result_top_0.044/${drug}.txt";
    open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";

    my $fo2 ="./output/huan_data_rwr/rwr_result_top_0.044_no_start/${drug}.txt"; 
    open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
    my (%hash2,%hash3);
        while(<$I2>)
    {
        chomp;
        my @f= split /\t/;
        my $start = $f[0];
        $hash2{$start}=1;
    }

    while(<$I3>)
    {
        chomp;
        my @f= split /\s+/;
        my $end = $f[0];
        my $score = $f[1];
        $hash3{$end}=$score;
    }

    foreach my $gene(sort keys %hash3){
        unless(exists $hash2{$gene}){
            my $score = $hash3{$gene};
            print $O2 "$gene\t$score\n";
        }
    }
    close $O2 or warn "$02 : failed to close output file '$fo2' : $!\n";
}