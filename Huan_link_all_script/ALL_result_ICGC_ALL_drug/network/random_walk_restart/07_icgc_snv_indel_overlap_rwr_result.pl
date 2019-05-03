 #对于每个药物，./output/huan_data_rwr/rwr_result_top_0.044_no_start/${drug}.txt 文件与../output/04_map_ICGC_snv_indel_in_network_num.txt 的交集，得文件./output/huan_data_rwr/rwr_result_top_0.044_no_start_overlap_ICGC_SNV_Indel/${drug}.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/03_huan_drug_target_num.txt";#输入的是drug target
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";

my $f2 ="../output/04_map_ICGC_snv_indel_in_network_num.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
 my %hash1;
 my %hash2;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drugname = $f[0];
        $hash1{$drugname}=1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^entrezgene/){
        my $gene = $f[0];
        my $network_id = $f[1];
        $hash2{$network_id}=1;
    }
}


foreach my $drug (sort keys %hash1){

    
    my $f3 ="./output/huan_data_rwr/rwr_result_top_0.044_no_start/${drug}.txt";
    open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";

    my $fo2 ="./output/huan_data_rwr/rwr_result_top_0.044_no_start_overlap_ICGC_SNV_Indel/${drug}.txt"; 
    open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
    my %hash3;

    while(<$I3>)
    {
        chomp;
        my @f= split /\s+/;
        my $end = $f[0];
        my $score = $f[1];
        $hash3{$end}=$score;
    }

    foreach my $gene(sort keys %hash3){
        if (exists $hash2{$gene}){
            my $score = $hash3{$gene};
            print $O2 "$gene\t$score\n";
        }
    }
    close $O2 or warn "$02 : failed to close output file '$fo2' : $!\n";
}