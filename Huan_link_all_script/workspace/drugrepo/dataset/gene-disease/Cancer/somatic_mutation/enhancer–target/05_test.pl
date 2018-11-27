#把final_protein_coding_all_enhancer_target_ensg.txt转成提取成标准的bed格式，得文件05_normal_merge_all_data.bed
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./final_protein_coding_all_enhancer_target_ensg.txt";
my $fo1 = "./05_normal_merge_all_data.bed";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#my $title = "region\tgene\tscore\tsource";
#print $O1 "$title\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^region/){
        my $region =$f[0];
        my $gene =$f[1];
        my $score = $f[2];
        my $source = $f[3];
        my @f1= split/\:/,$region;
        my $chr = $f1[0];
        my @f2 = split/\-/,$f1[1];
        my $start = $f2[0];
        my $end =$f2[1];
        $chr =~s/chr//g;
        my $output = "$chr\t$start\t$end\t$region\t$gene\t$score\t$source";
        unless(exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
        
      
    }
}
close $I1 or warn "$0 : failed to close output file '$f1' : $!\n";
