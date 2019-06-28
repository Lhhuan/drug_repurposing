#将./B_sift_tmp/missense_match_bscore.txt 中的LOF 和GOF 区分出来，并和./B_sift_tmp/varient_lof.txt merge 到一起，得./output/01_merge_missense_and_lof_vraint_moa.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./B_sift_tmp/missense_match_bscore.txt";
my $f2 ="./B_sift_tmp/varient_lof.txt";
my $fo1 ="./output/01_merge_missense_and_lof_vraint_moa.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Variant_id\tENSG\tConsequence\tProtein\tB_sift_score\tMOA\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $variant_id = $f[0];
    my $ENSG = $f[3];
    my $consequence = $f[6];
    my $protein= $f[13];
    my $B_sift_score = $f[-1];
    if ($B_sift_score >0.5){
        my $MOA = "GOF";
        my $output = "$variant_id\t$ENSG\t$consequence\t$protein\t$B_sift_score\t$MOA";
        unless(exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
    elsif($B_sift_score < -0.95){
        my $MOA = "LOF";
        my $output = "$variant_id\t$ENSG\t$consequence\t$protein\t$B_sift_score\t$MOA";
        unless(exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
    else{
        my $MOA = "NA";
        my $output = "$variant_id\t$ENSG\t$consequence\t$protein\t$B_sift_score\t$MOA";
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
    my $variant_id = $f[0];
    my $ENSG = $f[3];
    my $consequence = $f[6];
    my $protein= $f[13];
    my $B_sift_score = "NA";
    my $MOA = "LOF";
    my $output = "$variant_id\t$ENSG\t$consequence\t$protein\t$B_sift_score\t$MOA";
    unless(exists $hash1{$output}){
        $hash1{$output} =1;
        print $O1 "$output\n";
    }
}
