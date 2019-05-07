#用../simple_somatic_mutation.largethan0.vcf 提取./no_cadd_score.txt中的位置和ref alt，得./no_cadd_pos.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./no_cadd_score.txt";
# my $f2 = "../12_add_mutation_ensg_entrezid_info.txt";
my $f3 = "../simple_somatic_mutation.largethan0.vcf";
my $fo1 = "./no_cadd_pos.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);


while(<$I1>)
{
    chomp;
    $hash1{$_}=1;
}

while(<$I3>)
{
    chomp;
    unless (/^#/){
        my @f = split/\s+/;
        my $chr = $f[0];
        my $pos = $f[1];
        my $ref = $f[3];
        my $alt = $f[4];
        my $mutation_id = $f[2];
        my $output = join("\t",@f[0..4]);
        if (exists $hash1{$mutation_id}){
            print $O1 "$output\n"
        }
    }
}
