#把ds_res.csv转成.bed,得文件02_noncoding_path.bed
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./ds_res.csv";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo2 = "./02_noncoding_path.bed";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

#print $O2 "chr\tstart\tend\tref\talt\n";

while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
    my $chr = $f[0];
    my $pos = $f[1];
    my $ref = $f[2];
    my $alt = $f[3];  
    my $start = $pos -1;
    print $O2 "chr$chr\t$start\t$pos\t$ref\t$alt\n";           
}