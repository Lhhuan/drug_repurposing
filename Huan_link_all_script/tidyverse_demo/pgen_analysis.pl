#!/usr/bin/perl

use warnings;
use strict;

my $dir_out = "output_perl";
my $fi      = "pgen.tsv";
my $fo      = "$dir_out/pgen_brief.tsv";
open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$' : $!\n";
select $O;
print join "\t", "SNP", "gene", "chr", "posSNP", "posTSS", "distanceTSS",
  "rho", "pvalue", "group";
print "\n";

while (<$I>) {
    if (/^rs\d+/) {
        my @fields = split /\t/;
        my $chr    = "chr" . $fields[3];
        my $group =
          $fields[7] >= 50000
          ? "Large"
          : ( $fields[7] >= 20000 ? "Middle" : "Small" );
        print join "\t", $fields[0], $fields[2], $chr, @fields[ 5 .. 9 ],
          $group;
        print "\n";
    }
}
close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$' : $!\n";

