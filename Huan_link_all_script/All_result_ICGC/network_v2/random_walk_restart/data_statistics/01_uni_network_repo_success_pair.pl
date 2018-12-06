#对../13_network_based_ICGC_somatic_repo_may_success.txt的drug和repo进行提取并且去重，得01_uni_network_repo_success_pair.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../13_network_based_ICGC_somatic_repo_may_success.txt";
my $fo1 ="./01_uni_network_repo_success_pair.txt"; 

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
# print $O1 "cancer\tdrug_num\n";

my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^start_id/){
        my $cancer = $f[7];
        my $drug = $f[9];
        my $out = "$drug\t$cancer";
        #print STDERR "1234\n";
        unless(exists $hash1{$out}){
            $hash1{$out} =1;
            print $O1 "$out\n";
        }
     }
}

