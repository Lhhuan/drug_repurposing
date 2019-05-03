# #将./v4/SV/refine_TRA_hotspot_score, ./v4/SV/INV_hotspot_score,./v4/SV/DEL_hotspot_score, ./v4/SV/DUP_hotspot_score, ./v4/CNV/All_CNV_hotspot_score merge到一起，得./v4/output/all_sv_snv.vcf

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./v4/SV/refine_TRA_hotspot_score";
my $f2 = "./v4/SV/INV_hotspot_score";
my $f3 = "./v4/SV/DEL_hotspot_score";
my $f4 = "./v4/SV/DUP_hotspot_score";
my $f5 = "./v4/CNV/All_CNV_hotspot_score";
my $fo1 = "./v4/output/all_sv_snv.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

print $O1 "POS\tScore\tProject\tID\tSource\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless  (/^chr1/){
        my @f =split/\t/;
        my $k = join(";",@f[0..5]);
        my $score = $f[6];
        my $project = $f[7];
        my $number = $.;
        my $id = "TRA"."$number";
        print $O1 "$k\t$score\t$project\t$id\tTranslocation\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless  (/^chr1/){
        my @f =split/\t/;
        my $k = join(";",@f[0..5]);
        my $score = $f[6];
        my $project = $f[7];
        my $number = $.;
        my $id = "INV"."$number";
        print $O1 "$k\t$score\t$project\t$id\tInversion\n";
    }
}


while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless  (/^chr/){
        my @f =split/\t/;
        my $k = join(";",@f[0..2]);
        my $score = $f[3];
        my $project = $f[4];
        my $number = $.;
        my $id = "DEL"."$number";
        print $O1 "$k\t$score\t$project\t$id\tDeletion\n";
    }
}

while(<$I4>)
{
    chomp;
    my @f= split/\t/;
    unless  (/^chr/){
        my @f =split/\t/;
        my $k = join(";",@f[0..2]);
        my $score = $f[3];
        my $project = $f[4];
        my $number = $.;
        my $id = "DUP"."$number";
        print $O1 "$k\t$score\t$project\t$id\tDuplication\n";
    }
}

while(<$I5>)
{
    chomp;
    my @f= split/\t/;
    unless  (/^chr/){
        my @f =split/\t/;
        my $k = join(";",@f[0..2]);
        my $score = $f[3];
        my $project = $f[4];
        my $number = $.;
        my $id = "CNV"."$number";
        print $O1 "$k\t$score\t$project\t$id\tCNV\n";
    }
}
