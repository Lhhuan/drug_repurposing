#!/usr/bin/perl

use warnings;
use strict;

my $dir_out    = "output_perl";
my $file_genes = "genes.tsv";
my $file_out   = "$dir_out/genes_brief.tsv";
open my $I, '<', $file_genes
  or die "$0 : failed to open input file '$file_genes' : $!\n";
open my $O, '>', $file_out
  or die "$0 : failed to open output file '$file_out' : $!\n";
select $O;
print join "\t", "PharmGKB", "NCBI", "Symbol", "Chr", "Start", "End", "Length",
  "Name";
print "\n";
my %number;

while (<$I>) {
    chomp;
    unless (/^Pham/) {
        my @fields = split /\t/;
        if ( $fields[1] =~ /\d/ && $fields[2] =~ /\d/ && $fields[3] =~ /\w/ ) {
            my $length = $fields[-1] - $fields[-2];
            $number{ $fields[-3] }++;
            print join "\t", @fields[ 0, 1, 5, -3, -2, -1 ], $length,
              $fields[4];
            print "\n";
        }
    }
}
close $I or warn "$0 : failed to close input file '$file_genes' : $!\n";
close $O or warn "$0 : failed to close output file '$file_out' : $!\n";

my $file_number = "$dir_out/genes_chr_num.tsv";
open my $ON, '>', $file_number
  or die "$0 : failed to open output file '$file_number' : $!\n";
select $ON;
print "Chr\tCount\n";
foreach my $key ( sort { $number{$b} <=> $number{$a} } keys %number ) {
    print "$key\t$number{$key}\n";
}
close $ON or warn "$0 : failed to close output file '$file_number' : $!\n";

