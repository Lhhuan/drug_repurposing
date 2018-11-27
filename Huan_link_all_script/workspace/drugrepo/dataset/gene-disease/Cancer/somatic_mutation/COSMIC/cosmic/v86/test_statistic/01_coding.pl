#将coding 文件中，出现三次以上的variant筛选出来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  

my $fo1 = "./coding_unique_ref_alt.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;


open my $DATE, 'zcat ../CosmicCodingMuts.vcf.gz|' or die "zcat CosmicCodingMuts.vcf.gz $0: $!\n"; 
my %hash1;
while(<$DATE>)
{
     chomp();  
     unless(/^#/){
        my @f1 = split /\s+/;
        my $chrom = $f1[0];
        my $pos = $f1[1];
        my $ref = $f1[3];
        my $alt = $f1[4];
        my $k = "$ref\t$alt";
        unless(exists $hash1{$k}){
            $hash1{$k} =1;
            print $O1 "$k\n";
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
