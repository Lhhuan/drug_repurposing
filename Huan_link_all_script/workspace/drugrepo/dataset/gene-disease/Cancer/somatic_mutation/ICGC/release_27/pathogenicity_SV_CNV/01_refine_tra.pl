#因为./v4/SV/TRA_hotspot_score 中有两条重复的记录，但他们的project 不相同。把他们的project 合并得./v4/SV/refine_TRA_hotspot_score

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./v4/SV/TRA_hotspot_score";
my $fo1 = "./v4/SV/refine_TRA_hotspot_score";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    if (/^chr1/){
        print $O1 "$_\n";
    }
    else{
        my @f =split/\t/;
        my $k = join("\t",@f[0..6]);
        my $project = $f[7];
        push @{$hash1{$k}},$project;
    }
}

foreach my $k (sort keys %hash1){
    my @projects = @{$hash1{$k}};
    my $project = join(",",@projects);
    print $O1 "$k\t$project\n";
}

