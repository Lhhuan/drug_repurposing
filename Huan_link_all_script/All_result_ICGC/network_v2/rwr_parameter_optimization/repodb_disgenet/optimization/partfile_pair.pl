#得到所有partfile的组合pair
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my @partfile1 = (80,90,100,200,300,400,500,600,700,800,900,1000);
for my $part1(@partfile1){
    for my $part2(@partfile1){
            print "$part1\t$part2\n";
        }
}