#将./pathogenic_hotspot/del_svscore_pathogenic_hotspot.txt 中的project拆分开得./pathogenic_hotspot/del_svscore_pathogenic_hotspot_project_split.txt，
#并统计每个project下有多少hotspot,得./pathogenic_hotspot/project_pathogenic_hotspot_del.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./pathogenic_hotspot/del_svscore_pathogenic_hotspot.txt";
my $fo1 ="./pathogenic_hotspot/del_svscore_pathogenic_hotspot_project_split.txt";  
my $fo2 ="./pathogenic_hotspot/project_pathogenic_hotspot_del.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

print $O1 "hotspot\tproject\tSVSCORETOP10\n";
print $O2 "project\tnumber_of_hotspot\n";

my (%hash1,%hash2);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#CHR1/){
        my $pos = join(",",@f[0..2]) ;
        my $PROJECT= $f[3];
        my $SVSCORETOP10 =$f[4];
        my @ts = split/\,/,$PROJECT;
        foreach my $t(@ts){
            push @{$hash1{$t}},$pos;
            my $output = "$pos\t$t\t$SVSCORETOP10";
            unless (exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
    }
}

foreach my $project (sort keys %hash1){
    my @hotspots = @{$hash1{$project}};
    my %hash3;
    @hotspots = grep { ++$hash3{$_} < 2 } @hotspots; #对数组内元素去重
    my $n_hotspot = @hotspots;
    print $O2 "$project\t$n_hotspot\n";
}