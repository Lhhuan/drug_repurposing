#统计../output/06_filter_snv_in_pathogenicity_icgc.txt中每个sample 的pathogenicity mutation的数目，得../output/06_sample_pathogenicity_mutation_number.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;



my $f1 = "../output/06_filter_snv_in_pathogenicity_icgc.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 = "../output/06_sample_pathogenicity_mutation_number.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;
print $O1 "Sample\tmutation_number\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id/){
        my $Mutation_ID = $f[0];
        my $paper_sample_name = $f[2];
        my $Mutation_id = $f[-1];
        push @{$hash1{$paper_sample_name}},$Mutation_id;
    }
}

foreach my $sample(sort keys %hash1){
    my @Mutation_ids = @{$hash1{$sample}};
    my %hash2;
    @Mutation_ids = grep{ ++$hash2{$_} <2}@Mutation_ids;
    print "$sample\t@Mutation_ids\n";
    my $number = @Mutation_ids;
    print $O1 "$sample\t$number\n";
}