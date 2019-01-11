#看./output/11_prediction_and_icgc_result_top0.1.txt和./output/11_prediction_and_icgc_result_sorted_by_value_in_paper_top_0.1.txt的overlap
#得./output/12_value_in_paper_top0.1_overlap_prediction_top0.1.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;

my $f1 = "./output/11_prediction_and_icgc_result_top0.1.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/11_prediction_and_icgc_result_sorted_by_value_in_paper_top_0.1.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/12_value_in_paper_top0.1_overlap_prediction_top0.1.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_in_paper\toncotree_id\toncotree_id_type\tpaper_sample_name\tpredict_value\tvalue_in_paper";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug/){
        my @f =split/\t/;
        my $k=$_;
        $hash1{$k}=1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug/){
        my @f =split/\t/;
        my $k=$_;
        if (exists $hash1{$k}){
            print $O1 "$k\n";
        }
    }
}
