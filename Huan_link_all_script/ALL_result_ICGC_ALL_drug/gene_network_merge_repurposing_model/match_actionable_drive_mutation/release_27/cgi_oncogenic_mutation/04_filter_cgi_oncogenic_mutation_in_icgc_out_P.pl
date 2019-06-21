#将不在./output/in_pathogenicity_cgi.txt 但./output/in_icgc_add_cgi.txt 中mutation提取出来，得./output/04_out_pathogenicity_In_ICGC.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/in_pathogenicity_cgi.txt";
my $f2 = "./output/in_icgc_add_cgi.txt";
my $fo1 = "./output/04_out_pathogenicity_In_ICGC.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Mutation_ID/){
        my $Mutation_ID = $f[0];
        $hash1{$Mutation_ID}=1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Mutation_ID/){
       my $Mutation_ID = $f[0];
       unless(exists $hash1{$Mutation_ID}){
           print $O1 "$Mutation_ID\n";
       }
    }
}
