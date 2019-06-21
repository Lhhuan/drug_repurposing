#将./output/01_unique_cgi_out_icgc_cancer.txt和./output/cancer_acronyms.txt merge 到一起，得./output/02_unique_cgi_out_icgc_cancer_name.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/01_unique_cgi_out_icgc_cancer.txt";
my $f2 = "./output/cancer_acronyms.txt";
my $fo1 = "./output/02_unique_cgi_out_icgc_cancer_name.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
# print $O2 "Mutation_ID\thgvsg\n";


while(<$I1>)
{
    chomp;
    $hash1{$_}=1;
}

while(<$I2>)
{
    chomp;
    if (/^acronym/){
        print $O1 "$_\n";
    }
    else{
        my @f = split/\t/;
        my $acronym =$f[0];
        my $cancer =$f[1];
        if (exists $hash1{$acronym}){
            print $O1 "$_\n";
        }
    }
}