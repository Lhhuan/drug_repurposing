 
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./01_mutation_in_protein_coding_map_gene.vcf";
my $fo1 = "./01_check_result_protein.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    unless (/^#/){
        my @f= split/\t/;
        my $mutation_id = $f[0];
        my $ensg = $f[3];
        my $map_to_gene_level= $f[-1];
        my $output = "$mutation_id\t$ensg\t$map_to_gene_level";
        unless (exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}
close($O1);

my $f2 = "./01_check_result_protein.txt";
my $fo2 = "./01_check_result_MUTATION_num.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";


while(<$I2>)
{
    chomp;
    unless (/^#/){
        my @f= split/\t/;
        my $mutation_id = $f[0];
        my $ensg = $f[1];
        my $map_to_gene_level= $f[2];
        # my $v = "$ensg\t$map_to_gene_level";
        my $v = $map_to_gene_level;
        push @{$hash2{$mutation_id}},$v;
    }
}

foreach my $mutation_id(sort keys %hash2){
    my @vs = @{$hash2{$mutation_id}};
    my %hash14;
    @vs = grep { ++$hash14{$_} < 2 }  @vs; #对数组内元素去重
    my $number = @vs;
    if ($number>1){
        foreach my $v(@vs){
            print $O2 "$mutation_id\t$v\n";
        }
    }
}