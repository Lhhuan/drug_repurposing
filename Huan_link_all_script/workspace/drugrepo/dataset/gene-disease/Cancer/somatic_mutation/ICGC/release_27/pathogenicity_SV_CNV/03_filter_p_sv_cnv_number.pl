#将./v4/output/all_sv_snv.vcf中cadd fre score >=15的筛选出来，得./v4/output/all_pathogenicity_sv_snv.vcf

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./v4/output/all_sv_snv.vcf";
my $fo1 = "./v4/output/all_pathogenicity_sv_snv.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2);

print $O1 "POS\tScore\tProject\tID\tSource\toccurance\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless  (/^POS/){
        my $pos = $f[0];
        my $score = $f[1];
        if($score>=15){
            print $O1 "$_\n";
        }
        else{
            print "$_\n";
        }
    }
}