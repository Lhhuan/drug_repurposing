#对于每个药物，用./output/huan_data_rwr/start/${drug}.txt和./output/huan_data_rwr/rwr_result_top_0.044_no_start_overlap_ICGC_SNV_Indel/${drug}.txt 
#穷举出所有的start和end pair, 用于走最短路径文件存到./output/huan_data_rwr/the_shortest_path_start_end/${drug}.txt ，
#得总文件./output/08_drug_start_end_pair_to_shortest.txt，和逗号分割start的文件./output/08_drug_start_comma_end.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/03_huan_drug_target_num.txt";#输入的是drug target
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/08_drug_start_end_pair_to_shortest.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "drug\tstart\tend\tscore\n";
my $fo3 ="./output/08_drug_start_comma_end.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
print $O3 "drug\tstart\tend\tscore\n";

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
    my $f3 ="./output/huan_data_rwr/rwr_result_top_0.044_no_start_overlap_ICGC_SNV_Indel/${drug}.txt";
    open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";

    my $fo2 ="./output/huan_data_rwr/the_shortest_path_start_end/${drug}.txt"; 
    open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
    print $O2 "start\tend\tscore\n";
    my %hash2;
    my %hash3;
    my %hash4;
    my @starts = ();
        while(<$I2>)
    {
        chomp;
        my @f= split /\t/;
        unless(/^entrezgene/){
            my $gene = $f[0];
            $hash2{$gene}=1;
            push @starts,$gene;
        }
    }
    my $all_start = join(",",@starts);
    while(<$I3>)
    {
        chomp;
        my @f= split /\s+/;
        my $end = $f[0];
        my $score = $f[1];
        $hash3{$end}=$score;
    }

    foreach my $end(sort keys %hash3){
        
        my $score = $hash3{$end};
        print $O3 "$drug\t$all_start\t$end\t$score\n";
        foreach my $start (sort keys %hash2){
            my $out = "$start\t$end\t$score";
            unless(exists $hash4{$out}){
                $hash4{$out}=1;
                print $O2 "$out\n";
                print $O1 "$drug\t$out\n";
                #print STDERR "$out\n";
            }
        }
    }
    close $O2 or warn "$02 : failed to close output file '$fo2' : $!\n";
    close $I2 or warn "$02 : failed to close output file '$f2' : $!\n";
    close $I3 or warn "$02 : failed to close output file '$f3' : $!\n";
}

 close $I1 or warn "$02 : failed to close output file '$f1' : $!\n";