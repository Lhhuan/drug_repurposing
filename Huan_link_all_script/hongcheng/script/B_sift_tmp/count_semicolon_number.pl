#将../data/cancer_gene_census.txt ../data/oncokb_cancerGeneList.txt  和../data/cancermine_collated_and_ensg_symbol.txt merge到一起。得../output/05_three_source_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;

my $f1 ="./protein_mutinfos.txt";
# my $fo1 ="../output/05_three_source_gene.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
# print $O1 "Gene_symbol\tEntrez\tTumour_Types\tRole_in_Cancer\tSource\n";

my(%hash1,%hash2);
my @numbers;
while(<$I1>)
{
    chomp;
    my @f= split /\;/;
    my $sub_number =  @f;
    push @numbers, $sub_number;
}
my $number = sum @numbers;
print "$number\n";
my $line ="81956";
my $final_number = $number +$line ;
print "final number is $final_number\n";
