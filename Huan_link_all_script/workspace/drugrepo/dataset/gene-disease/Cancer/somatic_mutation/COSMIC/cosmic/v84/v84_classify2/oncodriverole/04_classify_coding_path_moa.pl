#将文件03_coding_path_moa.txt分类，分为lof，得文件04_coding_path_lof.txt，分为gof得文件04_coding_path_gof.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./03_coding_path_moa.txt";
my $fo1 = "./04_coding_path_lof.txt";
my $fo2 = "./04_coding_path_gof.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $title = "position\tref\talt\tENSG_ID\tsymbol\tmoa\n";
select $O1;
print $title;
select $O2;
print $title;

my(%hash1,%hash2,%hash3);
       
while(<$I1>)
{
    chomp;
    my @f = split /\t/;
    unless(/^position/){
        my $moa = $f[5];
        if ($moa=~/Loss/){
            print $O1 "$_\n";
        }
        else{
            print $O2 "$_\n";
        }
        
    }
}
                
